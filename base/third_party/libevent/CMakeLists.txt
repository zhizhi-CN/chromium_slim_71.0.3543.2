include(ChromiumBuildConfig)
include(ChromiumHelpers)

set(LIBEVENT_SRCS
    "buffer.c"
    "evbuffer.c"
    "evdns.c"
    "evdns.h"
    "event-config.h"
    "event-internal.h"
    "event.c"
    "event.h"
    "event_tagging.c"
    "evhttp.h"
    "evrpc-internal.h"
    "evrpc.c"
    "evrpc.h"
    "evsignal.h"
    "evutil.c"
    "evutil.h"
    "http-internal.h"
    "http.c"
    "log.c"
    "log.h"
    "min_heap.h"
    "poll.c"
    "select.c"
    "signal.c"
    "strlcpy-internal.h"
    "strlcpy.c"
)

set(LIBEVENT_ADDITIONAL_INCLUDES "")

if(IS_MAC OR IS_IOS)
    list(APPEND LIBEVENT_SRCS
        "kqueue.c"
        "mac/config.h"
        "mac/event-config.h"    
    )
    set(LIBEVENT_ADDITIONAL_INCLUDES "mac")
elseif(IS_LINUX)
    list(APPEND LIBEVENT_SRCS
        "epoll.c"
        "linux/config.h"
        "linux/event-config.h" 
    )
    set(LIBEVENT_ADDITIONAL_INCLUDES "linux")
elseif(IS_ANDROID)
    list(APPEND LIBEVENT_SRCS
        "android/config.h"
        "android/event-config.h"
        "epoll.c"
    )
    set(LIBEVENT_ADDITIONAL_INCLUDES "android")
endif()

chromium_cc_library(
    NAME
        libevent
    SRCS
        ${LIBEVENT_SRCS}
    DEFINES
        HAVE_CONFIG_H
    INCLUDES
        ${LIBEVENT_ADDITIONAL_INCLUDES}  
    COPTS
        "-Wno-null-pointer-subtraction"
        "-Wno-sign-compare"
        "-Wno-unused-but-set-variable"
)
