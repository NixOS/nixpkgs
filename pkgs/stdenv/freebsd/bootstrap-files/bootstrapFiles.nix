{ system }: ((import <nixpkgs> {}).callPackage ({ stdenv, pkgsCross, runCommand, lib, stdenvAdapters, buildPackages, ... }:
let
  pkgs = pkgsCross.${system};
  tar-all = name: pkgs: (runCommand name {} ''
    base=$PWD
    mkdir nix-support
    for dir in ${lib.concatStringsSep " " pkgs}; do
      cd "$dir/nix-support" 2>/dev/null || continue
      for f in $(find . -type f); do
        mkdir -p "$base/nix-support/$(dirname $f)"
        cat $f >>"$base/nix-support/$f"
      done
    done
    rm -f $base/nix-support/propagated-build-inputs
    tar -cJf $out ${lib.concatStringsSep " " (lib.flatten (map (pkg: ["-C" pkg "."]) pkgs))} -C $base ./nix-support
  '');
  static = import ./static.nix { inherit stdenvAdapters pkgs; };
in
  tar-all "${system}-bootstrap-files.tar.xz" ([
    # static programs
    static.patchelf
  ] ++ (with pkgs; [
    # dynamic programs
    bash                 # shell
    patch                # build dependency
    diffutils            # build dependency
    coreutils            # build dependency
    findutils            # build dependency
    gawk                 # build dependency
    gnumake              # build dependency
    gnugrep              # build dependency
    gnused               # build dependency
    gnutar               # unpack dependency
    gzip                 # unpack dependency
    bzip2                # unpack dependency
    xz                   # unpack dependency
    (lib.getBin curl)    # unpack dependency and git dependency
    iconv                # git dependency
    cacert.out           # curl dependency
    openssl.out          # curl dependency
    (lib.getBin openssl) # curl dependency
    binutils-unwrapped   # stdenv dependency
    llvmPackages_16.clang-unwrapped  # stdenv dependency
    (runCommand "bsdcp" {} "mkdir -p $out/bin; cp ${freebsd.cp}/bin/cp $out/bin/bsdcp")  # stdenv dependency

    # dynamic libraries
    freebsd.libc
    freebsd.libkvm
    freebsd.libdl
    freebsd.libcasper
    freebsd.libnv
    freebsd.libcapsicum
    libcxxrt
    zlib
    libxml2
    pcre2
    libffi
    ncurses
    libxml2
    readline
    gmp
    llvmPackages_16.libllvm
    (lib.getLib bzip2)
    (lib.getLib binutils-unwrapped)
    (lib.getLib llvmPackages_16.clang-unwrapped)
    (lib.getLib llvmPackages_16.libllvm)
    (lib.getLib llvmPackages_16.libcxx)
    (lib.getLib llvmPackages_16.libcxxabi)
    (lib.getLib llvmPackages_16.libunwind)
    (lib.getLib llvmPackages_16.compiler-rt)
    (lib.getLib curl)
    (lib.getLib nghttp2)
    (lib.getLib brotli)
    (lib.getLib libidn2)
    (lib.getLib zstd)
    (lib.getLib openssl)

    # headers
    (lib.getDev curl)
    (lib.getDev zlib)
    (lib.getDev libxml2)
    (lib.getDev pcre2)
    (lib.getDev libffi)
    (lib.getDev ncurses)
    (lib.getDev readline)
    (lib.getDev bzip2)
    (lib.getDev openssl)
    (lib.getDev llvmPackages_16.libcxx)
    (lib.getDev llvmPackages_16.libcxxabi)
    (lib.getDev llvmPackages_16.compiler-rt)
]))) {})
