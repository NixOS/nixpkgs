{ lib
, fetchurl
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "sof-firmware";
<<<<<<< HEAD
  version = "2.2.6";

  src = fetchurl {
    url = "https://github.com/thesofproject/sof-bin/releases/download/v${version}/sof-bin-v${version}.tar.gz";
    sha256 = "sha256-kyLCp2NtAoRcOyaYTVirj3jWP/THZtCEwxlqWF4ACQU=";
=======
  version = "2.2.4";

  src = fetchurl {
    url = "https://github.com/thesofproject/sof-bin/releases/download/v${version}/sof-bin-v${version}.tar.gz";
    sha256 = "sha256-zoquuhA6pWqCZiVSsPM/M6hZqhAI2L+8LCLwzPyMazo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware/intel
    cp -av sof-v${version} $out/lib/firmware/intel/sof
    cp -av sof-tplg-v${version} $out/lib/firmware/intel/sof-tplg
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/thesofproject/sof-bin/releases/tag/v${version}";
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden hmenke ];
    platforms = with platforms; linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
