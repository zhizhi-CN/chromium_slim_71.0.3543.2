from conans import ConanFile, CMake, tools
from conans.errors import ConanInvalidConfiguration

import os

class ChromiumBaseSlimConan(ConanFile):
    name = "ChromiumSlim"
    version = "71.0.3543.2"
    author = "jinggang.li@hiscene.com"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False], "dcheck_always_on":[True, False]}
    default_options = {"shared": False, "fPIC": True, "dcheck_always_on": False}
    generators = "CMakeDeps"
    
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
        if self.options.dcheck_always_on:
            _cmake.definitions["DCHECK_ALWAYS_ON"] = True        
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
        self.copy("*.h", src=self._build_subfolder, dst="include")
        
        _cmake = CMake(self)
        _cmake.configure(build_folder=self._build_subfolder)
        _cmake.install()

    def package_info(self):
        self.cpp_info.set_property("cmake_file_name", "ChromiumSlim")
        self.cpp_info.set_property("cmake_find_mode", "both")
        self.cpp_info.set_property("cmake_module_file_name", "ChromiumSlim")
        self.cpp_info.set_property("pkg_config_name", "ChromiumSlim")

        self.cpp_info.components["base"].set_property("cmake_target_name", "chromium::base")
        self.cpp_info.components["base"].includes= ["include"]
        self.cpp_info.components["base"].libs = ["chromium_base", "chromium_modp_b64"]
        self.cpp_info.components["base"].defines.append("NO_TCMALLOC")
        
        if self.options.dcheck_always_on:
            self.cpp_info.components["base"].defines.append("DCHECK_ALWAYS_ON")

        if self.settings.os not in ["Windows", "iOS"]:
            self.cpp_info.components["base"].libs += ["chromium_libevent"]
                        
        if self.settings.os == "Linux":
            self.cpp_info.components["base"].libs += [
                "chromium_xdg_mime",
                "chromium_xdg_user_dirs",
            ]
        if self.settings.os == "Windows":
            self.cpp_info.components["base"].defines.append("NOMINMAX")
            self.cpp_info.components["base"].defines.append("WIN32_LEAN_AND_MEAN")  
            self.cpp_info.components["base"].defines.append("UNICODE") 
            self.cpp_info.components["base"].defines.append("_UNICODE")
            self.cpp_info.components["base"].system_libs = [
                "cfgmgr32.lib",
                "powrprof.lib",
                "propsys.lib",
                "setupapi.lib",
                "userenv.lib",
                "winmm.lib",
                "shell32.lib",
                "dbghelp.lib",
                "version.lib",
                "shlwapi.lib",
                "ws2_32.lib",
                "wbemuuid.lib",
            ]

