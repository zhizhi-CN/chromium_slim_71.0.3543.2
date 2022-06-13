include(ChromiumBuildConfig)
include(ChromiumHelpers)

chromium_cc_library(
    NAME
        cpufeatures
    SRCS
        "cpu-features.c"
        "cpu-features.h"
)


