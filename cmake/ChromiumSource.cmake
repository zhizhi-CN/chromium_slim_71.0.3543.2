include(ChromiumBuildConfig)

set(sources_assignment_filter)

if (NOT IS_WIN)
    list(APPEND sources_assignment_filter
        ".*_win\.cc"
        ".*_win\.h"
        ".*_win_unittest\.cc"
        "^win/.*"
        ".*\.def$"
        ".*.rc$"
    )
endif()

if (NOT IS_NACL)
    list(APPEND sources_assignment_filter
        ".*_nacl\.h"
        ".*_nacl\.cc"
    )
endif()

if (NOT IS_MAC) 
    list(APPEND sources_assignment_filter
        ".*_mac\.h"
        ".*_mac\.cc"
        ".*_mac\.mm"
        ".*_mac_unittest\.h"
        ".*_mac_unittest\.cc"
        ".*_mac_unittest\.mm"
        "^mac/.*"
        ".*_cocoa\.h"
        ".*_cocoa\.cc"
        ".*_cocoa\.mm"
        ".*_cocoa_unittest\.h"
        ".*_cocoa_unittest\.cc"
        ".*_cocoa_unittest\.mm"
        "^cocoa/.*"
    )
endif()

if (NOT IS_IOS)
    list(APPEND sources_assignment_filter
        ".*_ios\.h"
        ".*_ios\.cc"
        ".*_ios\.mm"
        ".*_ios_unittest\.h"
        ".*_ios_unittest\.cc"
        ".*_ios_unittest\.mm"
        "^ios/.*"
    )
endif()

if (NOT IS_MAC AND NOT IS_IOS)
    list(APPEND sources_assignment_filter
        ".*.mm$"
    )
endif()

if (NOT IS_LINUX)
    list(APPEND sources_assignment_filter
        ".*_linux\.h"
        ".*_linux\.cc"
        ".*_linux_unittest\.h"
        ".*_linux_unittest\.cc"
        "linux/.*"
    )
endif()
if (NOT IS_ANDROID)
    list(APPEND sources_assignment_filter
        ".*_android.h"
        ".*_android.cc"
        ".*_android_unittest.h"
        ".*_android_unittest.cc"
        "^android/.*"
    )
endif()

if (NOT IS_CHROMEOS)
    list(APPEND sources_assignment_filter
        ".*_chromeos.h"
        ".*_chromeos.cc"
        ".*_chromeos_unittest.h"
        ".*_chromeos_unittest.cc"
        "^chromeos/*"
    )
endif()

function(chromium_source_append)
    cmake_parse_arguments(args
        "DISABLE_FILTER"
        "OUT_VAR"
        "FILTER;FILES"
        ${ARGN}
    )
    set(FINAL_FILES "")
    if (args_DISABLE_FILTER)
        set(FINAL_FILES ${args_FILES})
    else()
        if (NOT args_FILTER)
            set(args_FILTER ${sources_assignment_filter})
        endif()

        set(FINAL_FILES ${args_FILES})        
        foreach(regular_expression ${args_FILTER})
            # message(STATUS "----------------OUT_VAR${OUT_VAR}: ${regular_expression}-------------------")
            # message(STATUS ${FINAL_FILES})
            list(FILTER FINAL_FILES EXCLUDE REGEX ${regular_expression})
            # message(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
            # message(STATUS ${FINAL_FILES})
            # message(STATUS "----------------${regular_expression}-------------------")
        endforeach()
    endif()
    list(APPEND FINAL_FILES ${${args_OUT_VAR}})
    set(${args_OUT_VAR} ${FINAL_FILES} PARENT_SCOPE)
endfunction()

function(chromium_source_remove)
    cmake_parse_arguments(args
        ""
        "OUT_VAR"
        "FILTER;FILES"
        ${ARGN}
    )
    set(FINAL_FILES  ${${args_OUT_VAR}})
    list(REMOVE_ITEM FINAL_FILES ${args_FILES})
    set(${args_OUT_VAR} ${FINAL_FILES} PARENT_SCOPE)
endfunction()
