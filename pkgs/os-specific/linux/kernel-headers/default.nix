{ stdenvNoCC, lib, buildPackages, fetchurl, perl, elf-header
, bison, flex, rsync
, writeTextFile
}:

let

  # As part of building a hostPlatform=mips kernel, Linux creates and runs a
  # tiny utility `arch/mips/boot/tools/relocs_main.c` for the buildPlatform.
  # This utility references a glibc-specific header `byteswap.h`.  There is a
  # compatibility header in gnulib for most BSDs, but not for Darwin, so we
  # synthesize one here.
  darwin-endian-h = writeTextFile {
    name = "endian-h";
    text = ''
      #include <byteswap.h>
    '';
    destination = "/include/endian.h";
  };
  darwin-byteswap-h = writeTextFile {
    name = "byteswap-h";
    text = ''
      #pragma once
      #include <libkern/OSByteOrder.h>
      #define bswap_16 OSSwapInt16
      #define bswap_32 OSSwapInt32
      #define bswap_64 OSSwapInt64
    '';
    destination = "/include/byteswap.h";
  };

  makeLinuxHeaders = { src, version, patches ? [] }: stdenvNoCC.mkDerivation {
    inherit src;

    pname = "linux-headers";
    inherit version;

    ARCH = stdenvNoCC.hostPlatform.linuxArch;

    strictDeps = true;
    enableParallelBuilding = true;

    # It may look odd that we use `stdenvNoCC`, and yet explicit depend on a cc.
    # We do this so we have a build->build, not build->host, C compiler.
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    # `elf-header` is null when libc provides `elf.h`.
    nativeBuildInputs = [
      perl elf-header
    ] ++ lib.optionals stdenvNoCC.hostPlatform.isAndroid [
      bison flex rsync
    ] ++ lib.optionals (stdenvNoCC.buildPlatform.isDarwin &&
                        stdenvNoCC.hostPlatform.isMips) [
      darwin-endian-h
      darwin-byteswap-h
    ];

    extraIncludeDirs = lib.optionals (with stdenvNoCC.hostPlatform; isPower && is32bit && isBigEndian) ["ppc"];

    inherit patches;

    hardeningDisable = lib.optional stdenvNoCC.buildPlatform.isDarwin "format";

    makeFlags = [
      "SHELL=bash"
      # Avoid use of runtime build->host compilers for checks. These
      # checks only cared to work around bugs in very old compilers, so
      # these changes should be safe.
      "cc-version:=9999"
      "cc-fullversion:=999999"
      # `$(..)` expanded by make alone
      "HOSTCC:=$(CC_FOR_BUILD)"
      "HOSTCXX:=$(CXX_FOR_BUILD)"
    ];

    # Skip clean on darwin, case-sensitivity issues.
    buildPhase = lib.optionalString (!stdenvNoCC.buildPlatform.isDarwin) ''
      make mrproper $makeFlags
    '' + (if stdenvNoCC.hostPlatform.isAndroid then ''
      make defconfig
      make headers_install
    '' else ''
      make headers $makeFlags
    '');

    checkPhase = ''
      make headers_check $makeFlags
    '';

    # The following command requires rsync:
    #   make headers_install INSTALL_HDR_PATH=$out $makeFlags
    # but rsync depends on popt which does not compile on aarch64 without
    # updateAutotoolsGnuConfigScriptsHook which is not enabled in stage2,
    # so we replicate it with cp. This also reduces bootstrap closure size.
    installPhase = ''
      mkdir -p $out
      cp -r usr/include $out
      find $out -type f ! -name '*.h' -delete
    ''
    # Some builds (e.g. KVM) want a kernel.release.
    + ''
      mkdir -p $out/include/config
      echo "${version}-default" > $out/include/config/kernel.release
    '';

    meta = with lib; {
      description = "Header files and scripts for Linux kernel";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };
in {
  inherit makeLinuxHeaders;

  linuxHeaders = let version = "6.5"; in
    makeLinuxHeaders {
      inherit version;
      src = fetchurl {
        url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
        hash = "sha256-eldLvCCALqdrUsp/rwcmf3IEXoYbGJFcUnKpjCer+IQ=";
      };
      patches = [
         ./no-relocs.patch # for building x86 kernel headers on non-ELF platforms
      ];
    };
}
