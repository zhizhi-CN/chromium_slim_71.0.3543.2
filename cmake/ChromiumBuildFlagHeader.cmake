find_program(PYTHON_EXECUABLE
    NAMES
        "python.exe"
        "python.bat"
        "python.sh"
        "python"
    PATHS
    $ENV{PATH}
)

function(chromium_buildflag_header)
    cmake_parse_arguments(buildflag_header
        ""
        "NAME;HEADER;HEADER_DIR"
        "FLAGS;"
        ${ARGN}
    )

    set(response_file "${CMAKE_BINARY_DIR}/${buildflag_header_HEADER_DIR}/${buildflag_header_HEADER}.rsp")

    file(REMOVE ${response_file}) 
    file(APPEND ${response_file} "--flags" )
    
    foreach(flag ${buildflag_header_FLAGS})
        file(APPEND ${response_file} " ${flag}")
    endforeach()
    
    add_custom_command(
        OUTPUT
            "${CMAKE_BINARY_DIR}/${buildflag_header_HEADER_DIR}/${buildflag_header_HEADER}"
        COMMAND 
            ${PYTHON_EXECUABLE} ${PROJECT_SOURCE_DIR}/cmake/script/write_buildflag_header.py  
            "--output=${buildflag_header_HEADER}"
            "--gen-dir=${CMAKE_BINARY_DIR}/${buildflag_header_HEADER_DIR}"
            "--definitions=${response_file}" 
        COMMENT 
            "generate buildflag_header ${buildflag_header_HEADER}"            
    )

    add_library(${buildflag_header_NAME} INTERFACE)
    target_sources(${buildflag_header_NAME} INTERFACE "${CMAKE_BINARY_DIR}/${buildflag_header_HEADER_DIR}/${buildflag_header_HEADER}")
    target_include_directories(${buildflag_header_NAME}
        INTERFACE
            ${CMAKE_BINARY_DIR}
    )
    add_library(chromium::${buildflag_header_NAME} ALIAS ${buildflag_header_NAME})    
endfunction()