set(CHROMIUM_IDE_FOLDER chromium)

include(ChromiumConfigureCopts)
include(ChromiumInstallDirs)

# chromium_cc_library()
#
# CMake function to imitate Bazel's cc_library rule.
#
# Parameters:
# NAME: name of target (see Note)
# HDRS: List of public header files for the library
# SRCS: List of source files for the library
# LIBRARIES: List of other libraries to be linked in to the binary targets
# COPTS: List of private compile options
# DEFINES: List of public defines
# LINKOPTS: List of link options
# PUBLIC: Add this so that this library will be exported under Chromium::
# Also in IDE, target will appear in Chromium folder while non PUBLIC will be in Chromium/internal.
# TESTONLY: When added, this target will only be built if user passes -DCHROMIUM_RUN_TESTS=ON to CMake.
#
# Note:
# By default, chromium_cc_library will always create a library named chromium_${NAME},
# and alias target Chromium::${NAME}.  The Chromium:: form should always be used.
# This is to reduce namespace pollution.
#
# chromium_cc_library(
#   NAME
#     awesome
#   HDRS
#     "a.h"
#   SRCS
#     "a.cc"
# )
# chromium_cc_library(
#   NAME
#     fantastic_lib
#   SRCS
#     "b.cc"
#   LIBRARIES
#     Chromium::awesome # not "awesome" !
#   PUBLIC
# )
#
# chromium_cc_library(
#   NAME
#     main_lib
#   ...
#   LIBRARIES
#     Chromium::fantastic_lib
# )
#
# TODO: Implement "ALWAYSLINK"
function(chromium_cc_library)
  cmake_parse_arguments(CHROMIUM_CC_LIB
    "DISABLE_INSTALL;SHARED"
    "NAME"
    "HDRS;SRCS;COPTS;PUBLIC_COPTS;DEFINES;PUBLIC_DEFINES;LINKOPTS;PUBLIC_LINKOPTS;LIBRARIES;PUBLIC_LIBRARIES;INCLUDES;PUBLIC_INCLUDES"
    ${ARGN}
  )

  set(_NAME "${CHROMIUM_CC_LIB_NAME}")

  # Check if this is a header-only library
  # Note that as of February 2019, many popular OS's (for example, Ubuntu
  # 16.04 LTS) only come with cmake 3.5 by default.  For this reason, we can't
  # use list(FILTER...)
  set(CHROMIUM_CC_SRCS "${CHROMIUM_CC_LIB_SRCS}")
  foreach(src_file IN LISTS CHROMIUM_CC_SRCS)
    if(${src_file} MATCHES ".*\\.(h|inc)")
      list(REMOVE_ITEM CHROMIUM_CC_SRCS "${src_file}")
    endif()
  endforeach()
  if("${CHROMIUM_CC_SRCS}" STREQUAL "")
    set(CHROMIUM_CC_LIB_IS_INTERFACE 1)
  else()
    set(CHROMIUM_CC_LIB_IS_INTERFACE 0)
  endif()

  if(NOT CHROMIUM_CC_LIB_IS_INTERFACE)
    if (CHROMIUM_CC_LIB_SHARED)
      list(APPEND CHROMIUM_CC_LIB_INTERNAL_PUBLIC_DEFINES "COMPONENT_BUILD")     
      add_library(${_NAME} SHARED "")
    else()
      if (IS_POSIX AND "${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" AND NOT MSVC)
        list(APPEND CHROMIUM_CC_LIB_INTERNAL_PRIVATE_COPTS
            "-fPIC"
        )
      endif()     
      add_library(${_NAME} STATIC "")
    endif()

    target_sources(${_NAME} PRIVATE ${CHROMIUM_CC_LIB_SRCS} ${CHROMIUM_CC_LIB_HDRS})
    target_include_directories(${_NAME}
      PRIVATE
        $<BUILD_INTERFACE:${CHROMIUM_COMMON_INCLUDE_DIRS}>
        $<INSTALL_INTERFACE:${CHROMIUM_INSTALL_INCLUDEDIR}>
        ${CHROMIUM_CC_LIB_INCLUDES}
      PUBLIC
        ${CHROMIUM_CC_LIB_PUBLIC_INCLUDES}
    )
    target_compile_options(${_NAME}
      PRIVATE
        ${CHROMIUM_DEFAULT_COPTS}
        ${CHROMIUM_CC_LIB_COPTS}
        ${CHROMIUM_CC_LIB_INTERNAL_PRIVATE_COPTS}
      PUBLIC
        ${CHROMIUM_DEFAULT_PUBLIC_COPTS}
        ${CHROMIUM_CC_LIB_PUBLIC_COPTS}
    )

    target_link_libraries(${_NAME}
      PRIVATE 
        ${CHROMIUM_CC_LIB_LIBRARIES}
        ${CHROMIUM_CC_LIB_LINKOPTS}
        ${CHROMIUM_DEFAULT_LINKOPTS}
      PUBLIC
        ${CHROMIUM_DEFAULT_PUBLIC_LINKOPTS}
        ${CHROMIUM_CC_LIB_PUBLIC_LIBRARIES}
        ${CHROMIUM_CC_LIB_PUBLIC_LINKOPTS}
    )
    target_compile_definitions(${_NAME} 
      PRIVATE
        ${CHROMIUM_DEFAULT_DEFINES}
        ${CHROMIUM_CC_LIB_DEFINES}
      PUBLIC
        ${CHROMIUM_DEFAULT_PUBLIC_DEFINES}
        ${CHROMIUM_CC_LIB_PUBLIC_DEFINES}
        ${CHROMIUM_CC_LIB_INTERNAL_PUBLIC_DEFINES}
    )

    set_property(TARGET ${_NAME} PROPERTY FOLDER ${CHROMIUM_IDE_FOLDER})

    # INTERFACE libraries can't have the CXX_STANDARD property set
    set_property(TARGET ${_NAME} PROPERTY CXX_STANDARD ${CHROMIUM_CXX_STANDARD})
    set_property(TARGET ${_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)

    # When being installed, we lose the chromium_ prefix.  We want to put it back
    # to have properly named lib files.  This is a no-op when we are not being
    # installed.
    set_target_properties(${_NAME} PROPERTIES
      OUTPUT_NAME "chromium_${_NAME}"
    )
  else()
    # Generating header-only library
    add_library(${_NAME} INTERFACE)
    target_include_directories(${_NAME}
      INTERFACE
        $<BUILD_INTERFACE:${CHROMIUM_COMMON_INCLUDE_DIRS}>
        $<BUILD_INTERFACE:${CHROMIUM_GEN_INCLUDE_DIRS}>
        $<INSTALL_INTERFACE:${CHROMIUM_INSTALL_INCLUDEDIR}>
      )
    target_link_libraries(${_NAME}
      INTERFACE
        ${CHROMIUM_CC_LIB_LIBRARIES}
        ${CHROMIUM_CC_LIB_LINKOPTS}
        ${CHROMIUM_DEFAULT_LINKOPTS}
    )
    target_compile_definitions(${_NAME} INTERFACE ${CHROMIUM_CC_LIB_DEFINES})
  endif()

  # TODO currently we don't install googletest alongside abseil sources, so
  # installed abseil can't be tested.
  
  install(TARGETS ${_NAME} EXPORT ${PROJECT_NAME}Targets
        RUNTIME DESTINATION ${CHROMIUM_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CHROMIUM_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CHROMIUM_INSTALL_LIBDIR}
        PRIVATE_HEADER DESTINATION ${CHROMIUM_INSTALL_INCLUDEDIR}
        PUBLIC_HEADER DESTINATION ${CHROMIUM_INSTALL_INCLUDEDIR}
  )

  add_library(chromium::${CHROMIUM_CC_LIB_NAME} ALIAS ${_NAME})

  message(STATUS "Library: chromium::${CHROMIUM_CC_LIB_NAME}")
endfunction()
