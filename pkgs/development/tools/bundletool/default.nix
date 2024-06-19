{ lib, stdenvNoCC, fetchurl, makeBinaryWrapper, jre_headless }:

stdenvNoCC.mkDerivation rec {
  pname = "bundletool";
  version = "1.16.0";

  src = fetchurl {
    url = "https://github.com/google/bundletool/releases/download/${version}/bundletool-all-${version}.jar";
    sha256 = "sha256-ggeZb4Oig5r9WtboUy2nSF6gaHS4BiohqUs+Lrl+s5Y=";
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
    mainProgram = "bundletool";
    homepage = "https://developer.android.com/studio/command-line/bundletool";
    changelog = "https://github.com/google/bundletool/releases/tag/${version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ ];
    platforms = jre_headless.meta.platforms;
    license = licenses.asl20;
  };
}
