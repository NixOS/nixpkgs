{ system }: ((import <nixpkgs> {}).callPackage ({ stdenv, pkgsCross, runCommand, lib, stdenvAdapters, buildPackages, ... }:
let
  pkgs = pkgsCross.${system};
  tar-all = name: pkgs: (runCommand name {} ''
    tar -cJf $out ${lib.concatStringsSep " " (lib.flatten (map (pkg: ["-C" pkg "."]) pkgs))}
  '');
  static = import ./static.nix { inherit stdenvAdapters pkgs; };
in
  tar-all "${system}-bootstrap-files.tar.xz" ([
    static.patchelf
  ] ++ (with pkgs; [
    bash
    patch
    diffutils
    coreutils
    findutils
    gnutar
    gawk
    gnumake
    gnugrep
    gnused
    gzip
    bzip2
    xz
    binutils-unwrapped
    llvmPackages_16.clang-unwrapped

    freebsd.libc
    libiconv
    zlib
    libxml2
    pcre2
    libffi
    ncurses
    readline
    llvmPackages_16.libllvm
    llvmPackages_16.libcxx
    llvmPackages_16.libcxxabi
    llvmPackages_12.libunwind
    (lib.getLib bzip2)
    (lib.getLib llvmPackages_16.clang-unwrapped)
    (lib.getLib llvmPackages_16.libllvm)
]))) {})
