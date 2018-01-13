{ stdenvNoCC, lib, buildPackages
, buildPlatform, hostPlatform
, fetchurl, perl
}:

assert hostPlatform.isLinux;

with hostPlatform.platform.kernelHeadersBaseConfig;

let
  inherit (hostPlatform.platform) kernelHeadersBaseConfig;
  common = { version, sha256, patches ? null }: stdenvNoCC.mkDerivation {
    name = "linux-headers-${version}";

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
      inherit sha256;
    };

    targetConfig = if hostPlatform != buildPlatform then hostPlatform.config else null;

    platform = hostPlatform.platform.kernelArch;

    # It may look odd that we use `stdenvNoCC`, and yet explicit depend on a cc.
    # We do this so we have a build->build, not build->host, C compiler.
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [ perl ];

    extraIncludeDirs = lib.optional hostPlatform.isPowerPC ["ppc"];

    # "patches" array defaults to 'null' to avoid changing hash
    # and causing mass rebuild
    inherit patches;

    buildPhase = ''
      if test -n "$targetConfig"; then
         export ARCH=$platform
      fi
      make ${kernelHeadersBaseConfig} SHELL=bash
      make mrproper headers_check SHELL=bash
    '';

    installPhase = ''
      make INSTALL_HDR_PATH=$out headers_install

      # Some builds (e.g. KVM) want a kernel.release.
      mkdir -p $out/include/config
      echo "${version}-default" > $out/include/config/kernel.release
    '';

    # !!! hacky
    fixupPhase = ''
      ln -s asm $out/include/asm-$platform
      if test "$platform" = "i386" -o "$platform" = "x86_64"; then
        ln -s asm $out/include/asm-x86
      fi
    '';

    meta = with lib; {
      description = "Header files and scripts for Linux kernel";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };
in {

  linuxHeaders_4_4 = common {
    version = "4.4.10";
    sha256 = "1kpjvvd9q9wwr3314q5ymvxii4dv2d27295bzly225wlc552xhja";
  };

  linuxHeaders_4_14 = common {
    version = "4.14.13";
    sha256 = "0wjpwhrnnvf6l3zpkkxk34dl722w9yp8j3vnh0xzi3hgb8dnvd2a";

    patches = [
      (fetchurl {
        name = "uapi_libc_compat.patch";
        url = "https://patchwork.ozlabs.org/patch/854342/raw/";
        sha256 = "0qczlgqfbw0czx63wg2zgla15zpmcc76d00cb7qwl514ysm4ihmj";
      })
      (fetchurl {
        name = "struct_ethhdr.patch";
        url = "https://patchwork.ozlabs.org/patch/855293/raw/";
        sha256 = "0019nxilbgv986sswxyvii50l5l3n9yp4ysgnjdp9104plcq9956";
      })
    ];
  };
}
