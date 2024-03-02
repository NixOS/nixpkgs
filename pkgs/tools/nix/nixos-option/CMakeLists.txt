cmake_minimum_required (VERSION 2.6)
project (nixos-option)

set(NIX_DEV_INCLUDEPATH "" CACHE STRING "path to nix include directory")

add_executable(nixos-option nixos-option.cc libnix-copy-paste.cc)
target_include_directories(nixos-option PUBLIC "${NIX_DEV_INCLUDEPATH}")
target_link_libraries(nixos-option PRIVATE -lnixmain -lnixexpr -lnixstore -lnixutil -lnixcmd)
target_compile_features(nixos-option PRIVATE cxx_std_20)

install (TARGETS nixos-option DESTINATION bin)
