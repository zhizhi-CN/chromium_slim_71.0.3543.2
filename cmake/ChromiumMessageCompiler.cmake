find_program(PYTHON_EXECUABLE
    NAMES
        "python.exe"
        "python.bat"
        "python.sh"
        "python"
    PATHS
    $ENV{PATH}
)

function(chromium_message_compiler)
    cmake_parse_arguments(_MC
        ""
        "GEN_DIR;SOURCE"
        ""
        ${ARGN}
    )
    get_filename_component(FileName ${_MC_SOURCE} NAME_WE)

    set(response_file "${_MC_GEN_DIR}/${FileName}.rsp")

    file(REMOVE ${response_file}) 
    file(APPEND ${response_file} "-h=${_MC_GEN_DIR}/${FileName}.h" )
    file(APPEND ${response_file} "-r=${_MC_GEN_DIR}/${FileName}.rc" )
    file(APPEND ${response_file} "-u")

    execute_process(
        COMMAND 
            ${PYTHON_EXECUABLE} ${PROJECT_SOURCE_DIR}/cmake/script/message_compiler.py
            "${response_file}"
        WORKING_DIRECTORY 
            ${PROJECT_SOURCE_DIR}
        RESULT_VARIABLE 
            result
    )
endfunction(message_compiler)