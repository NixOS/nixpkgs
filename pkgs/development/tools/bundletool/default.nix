{ lib, stdenvNoCC, fetchurl, makeBinaryWrapper, jre_headless }:

stdenvNoCC.mkDerivation rec {
  pname = "bundletool";
<<<<<<< HEAD
  version = "1.15.4";

  src = fetchurl {
    url = "https://github.com/google/bundletool/releases/download/${version}/bundletool-all-${version}.jar";
    sha256 = "sha256-5fVFl9u1IR8FDo3dA9TXMam036VoTHaHkotlSo3cISo=";
=======
  version = "1.14.1";

  src = fetchurl {
    url = "https://github.com/google/bundletool/releases/download/${version}/bundletool-all-${version}.jar";
    sha256 = "sha256-L3j5yNBZ2xx+pKxv+yUnRmrwODjRULcPS3f+fe78oBE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre_headless}/bin/java $out/bin/bundletool --add-flags "-jar $src"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command-line tool to manipulate Android App Bundles";
    homepage = "https://developer.android.com/studio/command-line/bundletool";
    changelog = "https://github.com/google/bundletool/releases/tag/${version}";
<<<<<<< HEAD
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ marsam ];
    platforms = jre_headless.meta.platforms;
    license = licenses.asl20;
  };
}
