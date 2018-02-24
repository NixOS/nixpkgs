{ stdenv, fetchFromGitHub, buildPackages }:

let
  buildArmTrustedFirmware = { targetPlatforms
            , filesToInstall
            , installDir ? "$out"
            , platform
            , extraMakeFlags ? []
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    name = "arm-trusted-firmware-${platform}-${version}";
    version = "1.4";

    src = fetchFromGitHub {
      owner = "ARM-software";
      repo = "arm-trusted-firmware";
      rev = "b762fc7481c66b64eb98b6ff694d569e66253973";
      sha256 = "15m10dfgqkgw6rmzgfg1xzp1si9d5jwzyrcb7cp3y9ckj6mvp3i3";
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

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = https://github.com/ARM-software/arm-trusted-firmware;
      description = "A reference implementation of secure world software for ARMv8-A";
      license = licenses.bsd3;
      maintainers = [ maintainers.lopsided98 ];
      # TODO: Fix when #34444 is merged
      # platforms = targetPlatforms;
    } // extraMeta;
  } // builtins.removeAttrs args [ "extraMeta" ]);

in rec {
  inherit buildArmTrustedFirmware;

  armTrustedFirmwareRK3328 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3328";
    targetPlatforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
  };
}
