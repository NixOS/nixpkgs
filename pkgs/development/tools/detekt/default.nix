{ lib, stdenv, fetchurl, unzip, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "detekt";
  version = "1.22.0";

  src = fetchurl {
    url = "https://github.com/detekt/detekt/releases/download/v${version}/detekt-cli-${version}.zip";
    sha256 = "0gj16k9hf20iwk91lf058b0yqd6bdqc702h5brjfp4wlp3ichfvw";
  };

  dontUnpack = true;
  nativeBuildInputs = [ unzip makeWrapper ];

  preBuild = ''
    export JAVA_HOME=${jre_headless}
  '';

  installPhase = ''
    mkdir $out
    unzip $src -d $out
    mv $out/detekt-cli-${version}/* $out
    mv $out/bin/detekt-cli $out/bin/detekt
    mv $out/bin/detekt-cli.bat $out/bin/detekt.bat
    rm -rf $out/detekt-cli-${version}
  '';

  postFixup = ''
    wrapProgram $out/bin/detekt --prefix PATH : "${lib.makeBinPath [ jre_headless ]}"
  '';

  meta = with lib; {
    description = "A static code analysis tool for Kotlin";
    homepage = "https://detekt.dev/";
    license = licenses.asl20;
    platforms = jre_headless.meta.platforms;
    changelog = "https://github.com/detekt/detekt/releases";
    maintainers = with maintainers; [ SubhrajyotiSen ];
  };
}