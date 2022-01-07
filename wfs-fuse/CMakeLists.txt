project(wfs-fuse VERSION 1.0.0 LANGUAGES CXX)

add_executable(wfs-fuse src/wfs-fuse.cpp)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(${PROJECT_NAME} PRIVATE
  $<$<CXX_COMPILER_ID:MSVC>:/W4 /WX>
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Wpedantic -Werror>
)

get_property(wfs_include_dirs TARGET wfslib PROPERTY INCLUDE_DIRECTORIES)

target_include_directories(wfs-fuse PRIVATE ${wfs_include_dirs})

target_link_libraries(wfs-fuse
    PRIVATE
        wfslib
)
