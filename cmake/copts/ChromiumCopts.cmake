list(APPEND CHROMIUM_CLANG_CL_EXCEPTIONS_FLAGS
    "/D_HAS_EXCEPTIONS=0"
)

list(APPEND CHROMIUM_CLANG_CL_FLAGS
    "/W3"
    "-Wno-c++98-compat-pedantic"
    "-Wno-conversion"
    "-Wno-covered-switch-default"
    "-Wno-deprecated"
    "-Wno-disabled-macro-expansion"
    "-Wno-double-promotion"
    "-Wno-comma"
    "-Wno-extra-semi"
    "-Wno-extra-semi-stmt"
    "-Wno-packed"
    "-Wno-padded"
    "-Wno-sign-compare"
    "-Wno-float-conversion"
    "-Wno-float-equal"
    "-Wno-format-nonliteral"
    "-Wno-gcc-compat"
    "-Wno-global-constructors"
    "-Wno-exit-time-destructors"
    "-Wno-nested-anon-types"
    "-Wno-non-modular-include-in-module"
    "-Wno-old-style-cast"
    "-Wno-range-loop-analysis"
    "-Wno-reserved-id-macro"
    "-Wno-shorten-64-to-32"
    "-Wno-switch-enum"
    "-Wno-thread-safety-negative"
    "-Wno-unknown-warning-option"
    "-Wno-unreachable-code"
    "-Wno-unused-macros"
    "-Wno-weak-vtables"
    "-Wno-zero-as-null-pointer-constant"
    "-Wbitfield-enum-conversion"
    "-Wbool-conversion"
    "-Wconstant-conversion"
    "-Wenum-conversion"
    "-Wint-conversion"
    "-Wliteral-conversion"
    "-Wnon-literal-null-conversion"
    "-Wnull-conversion"
    "-Wobjc-literal-conversion"
    "-Wno-sign-conversion"
    "-Wstring-conversion"
    "-Wno-c99-extensions"
    "-Wno-deprecated-declarations"
    "-Wno-missing-noreturn"
    "-Wno-missing-prototypes"
    "-Wno-missing-variable-declarations"
    "-Wno-null-conversion"
    "-Wno-shadow"
    "-Wno-shift-sign-overflow"
    "-Wno-sign-compare"
    "-Wno-unused-function"
    "-Wno-unused-member-function"
    "-Wno-unused-parameter"
    "-Wno-unused-private-field"
    "-Wno-unused-template"
    "-Wno-used-but-marked-unused"
    "-Wno-zero-as-null-pointer-constant"
    "-Wno-gnu-zero-variadic-macro-arguments"
)

list(APPEND CHROMIUM_PUBLIC_CLANG_CL_FLAGS
    "/DNOMINMAX"
    "/DWIN32_LEAN_AND_MEAN"
    "/D_CRT_SECURE_NO_WARNINGS"
    "/D_SCL_SECURE_NO_WARNINGS"
    "/D_ENABLE_EXTENDED_ALIGNED_STORAGE"
)

list(APPEND CHROMIUM_LLVM_EXCEPTIONS_FLAGS
    "-fno-exceptions"
)

list(APPEND CHROMIUM_LLVM_FLAGS
    "-Wall" 
    "-Werror" 
    "-Wextra" 
    "-Wno-implicit-fallthrough"
    "-Wthread-safety" 
    "-Wno-extra-semi" 
    "-Wno-unknown-warning-option"
    "-Wno-builtin-macro-redefined"
    "-Wno-missing-field-initializers" 
    "-Wno-unused-parameter" 
    "-Wno-c++11-narrowing" 
    "-Wno-unneeded-internal-declaration" 
    "-Wno-undefined-var-template" 
    "-Wno-ignored-pragma-optimize" 
    "-Wno-shadow" 
    "-Wno-char-subscripts" 
    "-Wheader-hygiene" 
    "-Wstring-conversion" 
    "-Wno-nonportable-include-path"
    "-Wtautological-overlap-compare"     
    "-Wglobal-constructors" 
    "-Wexit-time-destructors" 
    "-Wno-global-constructors"
    "-Wno-deprecated-declarations"
    "-Wno-range-loop-analysis"
    "-Wno-implicit-int-float-conversion"
    "-Wno-deprecated-copy-with-user-provided-copy"
    "-Wno-defaulted-function-deleted"
)

list(APPEND CHROMIUM_LLVM_PUBLIC_FLAGS
    "-Wno-unknown-warning-option"
    "-Wno-defaulted-function-deleted"
    "-Wno-implicit-const-int-float-conversion"
)

list(APPEND CHROMIUM_MSVC_EXCEPTIONS_FLAGS
    "/D_HAS_EXCEPTIONS=0"
)

list(APPEND CHROMIUM_MSVC_FLAGS  
    "/W3" 
    "/utf-8"
    "/wd4005"
    "/wd4068"
    "/wd4180"
    "/wd4244"
    "/wd4312"
	"/wd4251"
    "/wd4267"
    "/wd4715"
    "/wd4503"
    "/wd4800"
    "/wd4838"
    "/wd4996"
    "/wd4018"
    "/wd4101"
)

list(APPEND CHROMIUM_MSVC_PUBLIC_FLAGS
    "/DNOMINMAX"
    "/DUNICODE"
    "/D_UNICODE"
    "/DWIN32_LEAN_AND_MEAN"    
    "/D_CRT_SECURE_NO_WARNINGS"
    "/D_SCL_SECURE_NO_WARNINGS"
    "/D_ENABLE_EXTENDED_ALIGNED_STORAGE"
    "/wd4275"
)

list(APPEND CHROMIUM_MSVC_LINKOPTS
    "-ignore:4221"
)

list(APPEND CHROMIUM_RANDOM_HWAES_ARM32_FLAGS
    "-mfpu=neon"
)

list(APPEND CHROMIUM_RANDOM_HWAES_ARM64_FLAGS
    "-march=armv8-a+crypto"
)

list(APPEND CHROMIUM_RANDOM_HWAES_MSVC_X64_FLAGS
    "/O2"
    "/Ob2"
)

list(APPEND CHROMIUM_RANDOM_HWAES_X64_FLAGS
    "-maes"
    "-msse4.1"
)
