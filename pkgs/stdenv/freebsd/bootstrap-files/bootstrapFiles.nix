{ system }: ((import <nixpkgs> {}).callPackage ({ stdenv, pkgsCross, runCommand, lib, stdenvAdapters, buildPackages, ... }:
let
  pkgs = pkgsCross.${system};
  tar-all = name: pkgs: (runCommand name {} ''
    tar -cJf $out ${lib.concatStringsSep " " (lib.flatten (map (pkg: ["-C" pkg "."]) pkgs))}
  '');
  static = import ./static.nix { inherit stdenvAdapters pkgs; };
in
  tar-all "${system}-bootstrap-files.tar.xz" ([
    # static programs
    static.patchelf
  ] ++ (with pkgs; [
    # dynamic programs
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
    (runCommand "bsdcp" {} "mkdir -p $out/bin; cp ${freebsd.cp}/bin/cp $out/bin/bsdcp")

    # dynamic libraries
    freebsd.libc
    freebsd.libkvm
    freebsd.libdl
    #freebsd.libcxx
    #freebsd.libcxxrt
    libcxxrt
    libiconv
    zlib
    libxml2
    pcre2
    libffi
    ncurses
    readline
    llvmPackages_16.libllvm
    (lib.getLib bzip2)
    (lib.getLib llvmPackages_16.clang-unwrapped)
    (lib.getLib llvmPackages_16.libllvm)
    (lib.getLib llvmPackages_16.libcxx)
    (lib.getLib llvmPackages_16.libcxxabi)
    (lib.getLib llvmPackages_16.libunwind)
    (lib.getLib llvmPackages_16.compiler-rt)

    # headers
    (lib.getDev libiconv)
    (lib.getDev zlib)
    (lib.getDev libxml2)
    (lib.getDev pcre2)
    (lib.getDev libffi)
    (lib.getDev ncurses)
    (lib.getDev readline)
    (lib.getDev bzip2)
    (lib.getDev llvmPackages_16.libcxx)
    (lib.getDev llvmPackages_16.libcxxabi)
    (lib.getDev llvmPackages_16.compiler-rt)
]))) {})
