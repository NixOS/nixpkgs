{ stdenv
, fetchFromGitHub
, hostPlatform
}:

let
  buildArmTrustedFirmware = { targetPlatforms
     , platform
     , filesToInstall
     , installDir ? "$out"
     , version ? "1.4"
     , src ? (fetchFromGitHub {
         owner = "ARM-software";
         repo = "arm-trusted-firmware";
         rev = "v${version}";
         sha256 = "15m10dfgqkgw6rmzgfg1xzp1si9d5jwzyrcb7cp3y9ckj6mvp3i3";
       })
     , extraMeta ? {}
     , ... } @ args:
  stdenv.mkDerivation (rec {
    inherit src;

    name = "arm-trusted-firmware-${platform}-${version}";

    hardeningDisable = [ "all" ];

    makeFlags = ["PLAT=${platform}"];

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${stdenv.lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    dontStrip = true;

    meta = with stdenv.lib; {
      homepage = https://github.com/ARM-software/arm-trusted-firmware;
      description = "Reference implementation of secure world software for ARMv8-A";
      license = licenses.bsd3;
      maintainers = [ maintainers.samueldr ];
      platforms = targetPlatforms;
    } // extraMeta;
  } // args);

in rec {
  inherit buildArmTrustedFirmware;

  armTrustedFirmwareQemu = buildArmTrustedFirmware rec {
    platform = "qemu";
    targetPlatforms = ["aarch64-linux"];
    filesToInstall = [
      "build/${platform}/release/bl1.bin"
      "build/${platform}/release/bl2.bin"
      "build/${platform}/release/bl31.bin"
    ];
  };

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
    targetPlatforms = ["aarch64-linux"];
    filesToInstall = ["build/${platform}/release/bl31.bin"];
  };
}
