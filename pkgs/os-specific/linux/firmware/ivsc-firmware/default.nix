{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "ivsc-firmware";
  version = "unstable-2023-08-11";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ivsc-firmware";
    rev = "10c214fea5560060d387fbd2fb8a1af329cb6232";
    hash = "sha256-kEoA0yeGXuuB+jlMIhNm+SBljH+Ru7zt3PzGb+EPBPw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/vsc
    cp --no-preserve=mode --recursive ./firmware/* $out/lib/firmware/vsc/
    install -D ./LICENSE $out/share/doc

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware binaries for the Intel Vision Sensing Controller";
    homepage = "https://github.com/intel/ivsc-firmware";
    license = licenses.issl;
    sourceProvenance = with sourceTypes; [
      binaryFirmware
    ];
    maintainers = with maintainers; [
      hexa
    ];
    platforms = [ "x86_64-linux" ];
  };
}
