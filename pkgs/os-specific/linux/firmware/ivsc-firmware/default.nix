{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "ivsc-firmware";
  version = "unstable-2022-11-02";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ivsc-firmware";
    rev = "29c5eff4cdaf83e90ef2dcd2035a9cdff6343430";
    hash = "sha256-GuD1oTnDEs0HslJjXx26DkVQIe0eS+js4UoaTDa77ME=";
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
