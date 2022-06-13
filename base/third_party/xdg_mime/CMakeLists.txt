set(XDG_MIME_SRCS
    "xdgmime.c"
    "xdgmime.h"
    "xdgmimealias.c"
    "xdgmimealias.h"
    "xdgmimecache.c"
    "xdgmimecache.h"
    "xdgmimeglob.c"
    "xdgmimeglob.h"
    "xdgmimeicon.c"
    "xdgmimeicon.h"
    "xdgmimeint.c"
    "xdgmimeint.h"
    "xdgmimemagic.c"
    "xdgmimemagic.h"
    "xdgmimeparent.c"
    "xdgmimeparent.h"
)

chromium_cc_library(
    NAME
        xdg_mime
    SRCS
        ${XDG_MIME_SRCS}
    COPTS        
        "-Wno-sign-compare"        
)
    