cmake_minimum_required(VERSION 3.18)

# 70.0.3521.0

project(ChrmoumSlim)
set(CMAKE_CXX_STANDARD 17)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_LIST_DIR}/cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/copts
)

include(ChromiumBuildConfig)
include(ChromiumConfigureCopts)
include(ChromiumCopts)
include(ChromiumHelpers)

enable_language(ASM)
enable_language(CXX)

if (IS_MAC OR IS_IOS)
    enable_language(OBJC)
    enable_language(OBJCXX)

    set(CMAKE_OBJC_FLAGS ${CMAKE_C_FLAGS})
    set(CMAKE_OBJCXX_FLAGS ${CMAKE_CXX_FLAGS})
endif()



list(APPEND CHROMIUM_COMMON_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(base)
add_subdirectory(build)
add_subdirectory(third_party)

add_subdirectory(example)
