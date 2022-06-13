include(GNUInstallDirs)

# chromium_VERSION is only set if we are an LTS release being installed, in which
# case it may be into a system directory and so we need to make subdirectories
# for each installed version of Abseil.  This mechanism is implemented in
# Abseil's internal Copybara (https://github.com/google/copybara) workflows and
# isn't visible in the CMake buildsystem itself.

if(chromium_VERSION)
  set(CHROMIUM_SUBDIR "${PROJECT_NAME}_${PROJECT_VERSION}")
  set(CHROMIUM_INSTALL_BINDIR "${CMAKE_INSTALL_BINDIR}/${CHROMIUM_SUBDIR}")
  set(CHROMIUM_INSTALL_CONFIGDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${CHROMIUM_SUBDIR}")
  set(CHROMIUM_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/{CHROMIUM_SUBDIR}")
  set(CHROMIUM_INSTALL_LIBDIR "${CMAKE_INSTALL_LIBDIR}/${CHROMIUM_SUBDIR}")
else()
  set(CHROMIUM_INSTALL_BINDIR "${CMAKE_INSTALL_BINDIR}")
  set(CHROMIUM_INSTALL_CONFIGDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
  set(CHROMIUM_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}")
  set(CHROMIUM_INSTALL_LIBDIR "${CMAKE_INSTALL_LIBDIR}")
endif()