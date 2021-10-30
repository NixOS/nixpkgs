cmake_minimum_required (VERSION 2.6)
project (nixos-option)

add_executable(nixos-option nixos-option.cc libnix-copy-paste.cc)
target_link_libraries(nixos-option PRIVATE -lnixmain -lnixexpr -lnixstore -lnixutil)
target_compile_features(nixos-option PRIVATE cxx_std_17)

install (TARGETS nixos-option DESTINATION bin)
