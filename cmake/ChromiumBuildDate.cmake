find_program(PYTHON_EXECUABLE
    NAMES
        "python.exe"
        "python.bat"
        "python.sh"
        "python"
    PATHS
    $ENV{PATH}
)

function(chromium_build_date)
    cmake_parse_arguments(_BUILD_DATE
        ""
        "GEN_DIR"
        ""
        ${ARGN}
    )

    execute_process(
        COMMAND 
            ${PYTHON_EXECUABLE} ${PROJECT_SOURCE_DIR}/cmake/script/write_build_date_header.py  
            "${_BUILD_DATE_GEN_DIR}/generated_build_date.h"
            "official"
        WORKING_DIRECTORY 
            ${PROJECT_SOURCE_DIR}
        RESULT_VARIABLE 
            result
    )
endfunction()