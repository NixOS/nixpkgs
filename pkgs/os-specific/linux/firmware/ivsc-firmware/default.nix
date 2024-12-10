{
  lib,
  stdenv,
  fetchFromGitHub,
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

    mkdir -p $out/lib/firmware/vsc/soc_a1_prod
    # According to Intel's documentation for prod platform the a1_prod postfix is need it (https://github.com/intel/ivsc-firmware)
    # This fixes ipu6 webcams
    for file in $out/lib/firmware/vsc/*.bin; do
      ln -sf "$file" "$out/lib/firmware/vsc/soc_a1_prod/$(basename "$file" .bin)_a1_prod.bin"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware binaries for the Intel Vision Sensing Controller";
    homepage = "https://github.com/intel/ivsc-firmware";
    license = licenses.issl;
    sourceProvenance = with sourceTypes; [
      binaryFirmware
    ];
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
