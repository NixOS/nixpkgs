{ stdenv, fetchFromGitHub, buildPackages }:

let
  buildArmTrustedFirmware = { filesToInstall
            , installDir ? "$out"
            , platform
            , extraMakeFlags ? []
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    name = "arm-trusted-firmware-${platform}-${version}";
    version = "1.5";

    src = fetchFromGitHub {
      owner = "ARM-software";
      repo = "arm-trusted-firmware";
      rev = "refs/tags/v${version}";
      sha256 = "1gm0bn2llzfzz9bfsz11fhwxj5lxvyrq7bc13fjj033nljzxn7k8";
    };

    depsBuildBuild = [ buildPackages.stdenv.cc ];

    makeFlags = [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
      "PLAT=${platform}"
    ] ++ extraMakeFlags;

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${stdenv.lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    hardeningDisable = [ "all" ];
    dontStrip = true;

    # Fatal error: can't create build/sun50iw1p1/release/bl31/sunxi_clocks.o: No such file or directory
    enableParallelBuilding = false;

    meta = with stdenv.lib; {
      homepage = https://github.com/ARM-software/arm-trusted-firmware;
      description = "A reference implementation of secure world software for ARMv8-A";
      license = licenses.bsd3;
      maintainers = [ maintainers.lopsided98 ];
    } // extraMeta;
  } // builtins.removeAttrs args [ "extraMeta" ]);

in rec {
  inherit buildArmTrustedFirmware;

  armTrustedFirmwareAllwinner = buildArmTrustedFirmware rec {
    version = "1.0";
    src = fetchFromGitHub {
      owner = "apritzel";
      repo = "arm-trusted-firmware";
      # Branch: `allwinner`
      rev = "91f2402d941036a0db092d5375d0535c270b9121";
      sha256 = "0lbipkxb01w97r6ah8wdbwxir3013rp249fcqhlzh2gjwhp5l1ys";
    };
    platform = "sun50iw1p1";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["build/${platform}/release/bl31.bin"];
  };

  armTrustedFirmwareQemu = buildArmTrustedFirmware rec {
    platform = "qemu";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [
      "build/${platform}/release/bl1.bin"
      "build/${platform}/release/bl2.bin"
      "build/${platform}/release/bl31.bin"
    ];
  };

  armTrustedFirmwareRK3328 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3328";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
  };
}
