set(XDG_USER_DIRS_SRCS
    "xdg_user_dir_lookup.cc"
    "xdg_user_dir_lookup.h"
)

chromium_cc_library(
    NAME
        xdg_user_dirs
    SRCS
        ${XDG_USER_DIRS_SRCS}
    COPTS        
        "-Wno-sign-compare"
)
    