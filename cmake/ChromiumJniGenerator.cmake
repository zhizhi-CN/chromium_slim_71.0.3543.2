
find_program(PYTHON_EXECUABLE
    NAMES
        "python.exe"
        "python.bat"
        "python.sh"
        "python"
    PATHS
    $ENV{PATH}
)

find_program(JAVAP_EXECUABLE
    NAMES
        "javap.exe"
        "javap"
    PATHS
        $ENV{PATH}
)

function(chromium_generate_jar_jni)
    cmake_parse_arguments(generate_jar_jni
        ""
        "NAME;GEN_DIR;JAR"
        "CLASSES;INCLUDES"
        ${ARGN}
    )

    list(APPEND generate_jar_jni_INCLUDES "base/android/jni_generator/jni_generator_helper.h")

    set(_generated_hdrs_all "")
    foreach(CLASS ${generate_jar_jni_CLASSES})    
        get_filename_component(FileName ${CLASS} NAME_WE)
        set(JNI_HDR "${generate_jar_jni_GEN_DIR}/jni/${FileName}_jni.h")
        add_custom_command(
            OUTPUT
                ${JNI_HDR}
            COMMAND 
                ${PYTHON_EXECUABLE} ${CMAKE_SOURCE_DIR}/base/android/jni_generator/jni_generator.py
                "--jar_file=${generate_jar_jni_JAR}"
                "--input_file=${CLASS}"  
                "--output_dir=${generate_jar_jni_GEN_DIR}/jni"
                "--include=${generate_jar_jni_INCLUDES}"
                "--ptr_type=long"
                "--javap=${JAVAP_EXECUABLE}"
            COMMENT 
                "generate jni for[${CLASS}]-->${JNI_HDR}"
        )
        list(APPEND _generated_hdrs_all ${JNI_HDR})
    endforeach()
    set_source_files_properties(${_generated_hdrs_all} PROPERTIES GENERATED TRUE)

    add_library(${generate_jar_jni_NAME} INTERFACE)
    target_sources(${generate_jar_jni_NAME} INTERFACE ${_generated_hdrs_all})
    target_include_directories(${generate_jar_jni_NAME} INTERFACE ${generate_jar_jni_GEN_DIR})

    add_library(chromium::${generate_jar_jni_NAME} ALIAS ${generate_jar_jni_NAME})
endfunction()

function(chromium_generate_java_jni)
    cmake_parse_arguments(generate_java_jni
        ""
        "NAME;TARGET;GEN_DIR"
        "JAVA_SRCS;INCLUDES"
        ${ARGN}
    )


    list(APPEND generate_java_jni_INCLUDES "base/android/jni_generator/jni_generator_helper.h")

    set(_generated_hdrs_all "")
    foreach(INPUT_JAVA ${generate_java_jni_JAVA_SRCS})    
        get_filename_component(FileName ${INPUT_JAVA} NAME_WE)
        set(JNI_HDR "${generate_java_jni_GEN_DIR}/jni/${FileName}_Jni.h")
        add_custom_command(
            OUTPUT
                ${JNI_HDR}
            COMMAND 
                ${PYTHON_EXECUABLE} ${CMAKE_SOURCE_DIR}/base/android/jni_generator/jni_generator.py
                "--input_file=${INPUT_JAVA}" 
                "--output_dir=${generate_java_jni_GEN_DIR}/jni"
                "--include=${generate_java_jni_INCLUDES}"
                "--ptr_type=long"
            DEPENDS
                ${INPUT_JAVA}
            COMMENT 
                "generate jni for[${INPUT_JAVA}]-->${JNI_HDR}"
            VERBATIM
        )
        list(APPEND _generated_hdrs_all ${JNI_HDR})
    endforeach()
    set_source_files_properties(${_generated_hdrs_all} PROPERTIES GENERATED TRUE)

    add_library(${generate_java_jni_NAME} INTERFACE)
    target_include_directories(${generate_java_jni_NAME} INTERFACE ${generate_java_jni_GEN_DIR})
    target_sources(${generate_java_jni_NAME} INTERFACE ${_generated_hdrs_all})
    
    add_library(chromium::${generate_java_jni_NAME} ALIAS ${generate_java_jni_NAME})
endfunction()
