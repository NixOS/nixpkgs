project(wfs-fuse VERSION 1.0.0 LANGUAGES CXX)

find_package(FUSE)
if(NOT FUSE_FOUND)
    message(WARNING "fuse not found, not building wfs-fuse")
    return()
endif()

add_executable(${PROJECT_NAME} src/main.cpp)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
target_compile_options(${PROJECT_NAME} PRIVATE
  $<$<CXX_COMPILER_ID:MSVC>:/W4 /WX>
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Wpedantic -Werror -D_FILE_OFFSET_BITS=64>
)

if(BUILD_STATIC AND MSVC)
    set_property(TARGET ${PROJECT_NAME} PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

get_property(wfs_include_dirs TARGET wfslib PROPERTY INCLUDE_DIRECTORIES)

target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${wfs_include_dirs}
        ${FUSE_INCLUDE_DIR}
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        wfslib
        ${FUSE_LIBRARIES}
)
