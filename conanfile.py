from conans import ConanFile, CMake, tools
from conans.errors import ConanInvalidConfiguration

import os

class ChromiumBaseSlimConan(ConanFile):
    name = "ChromiumSlim"
    version = "71.0.3543.2"
    author = "jinggang.li@hiscene.com"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": True}
    generators = "cmake_find_package"

    build_policy = "missing"
    
    @property
    def _build_subfolder(self):
        return "build_subfolder"

    def export_sources(self):
        self.copy("CMakeLists.txt")
        self.copy("base/*")
        self.copy("build/*")
        self.copy("cmake/*")
        self.copy("example/*")
        self.copy("testing/*")
        self.copy("third_party/*")
                
    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def configure(self):
        if self.options.shared:
            del self.options.fPIC
        del self.settings.compiler.libcxx
        del self.settings.compiler.cppstd

    def build(self):
        _cmake = CMake(self)
        _cmake.configure(build_folder=self._build_subfolder)
        _cmake.verbose = True
        _cmake.build()
        
    def imports(self):
        pass
    
    def package(self):
        self.copy("base/*.h", dst="include")
        self.copy("build/*.h", dst="include")
        self.copy("testing/*.h", dst="include")
        self.copy("third_party/*.h", dst="include")

        _cmake = CMake(self)
        _cmake.configure(build_folder=self._build_subfolder)
        _cmake.install()

    def package_info(self):
        self.cpp_info.set_property("cmake_file_name", "ChromiumBaseSlim")
        self.cpp_info.components["base"].set_property("cmake_target_name", "chromium::base")
        self.cpp_info.components["base"].includes= ["include"]
        self.cpp_info.components["base"].libs = ["chromium_base"]
        
        if self.settings.os == "Windows":
            self.cpp_info.components["base"].system_libs = ["dbghelp","version","shlwapi","userenv","Winmm","Powrprof","ws2_32","SetupAPI"]
