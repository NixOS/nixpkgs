{ stdenvNoCC, lib, buildPackages, fetchurl, perl, elf-header }:

let
  makeLinuxHeaders = { src, version, patches ? [] }: stdenvNoCC.mkDerivation {
    inherit src;

    pname = "linux-headers";
    inherit version;

    ARCH = stdenvNoCC.hostPlatform.linuxArch;

    # It may look odd that we use `stdenvNoCC`, and yet explicit depend on a cc.
    # We do this so we have a build->build, not build->host, C compiler.
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    # `elf-header` is null when libc provides `elf.h`.
    nativeBuildInputs = [ perl elf-header ];

    extraIncludeDirs = lib.optional stdenvNoCC.hostPlatform.isPowerPC ["ppc"];

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
    '' + ''
      make headers $makeFlags
    '';

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

  linuxHeaders = let version = "5.10.9"; in
    makeLinuxHeaders {
      inherit version;
      src = fetchurl {
        url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "0la7dklpy6xd79fkzavpmlfyrc60kmmwz491msd95dmvv06kwwvz";
      };
      patches = [
         ./no-relocs.patch # for building x86 kernel headers on non-ELF platforms
      ];
    };
}
