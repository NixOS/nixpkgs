{ lib, stdenv, fetchurl, makeBinaryWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "bundletool";
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/google/bundletool/releases/download/${version}/bundletool-all-${version}.jar";
    sha256 = "sha256-xCw2Wuc2ndTcLrwR7uv5FFnwImxTcG/STeTQBiaKuIw=";
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
    maintainers = with maintainers; [ marsam ];
    platforms = jre_headless.meta.platforms;
    license = licenses.asl20;
  };
}
