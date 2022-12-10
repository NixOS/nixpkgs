{ lib, stdenv, fetchurl, unzip, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "detekt";
  version = "1.22.0";

  src = fetchurl {
    url = "https://github.com/detekt/detekt/releases/download/v${version}/detekt-cli-${version}.zip";
    sha256 = "0gj16k9hf20iwk91lf058b0yqd6bdqc702h5brjfp4wlp3ichfvw";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir $out
    unzip $src -d $out
    mv $out/detekt-cli-$version/* $out
    rm -rf $out/detekt-cli-$version
  '';

  postFixup = ''
    wrapProgram $out/bin/detekt-cli --prefix PATH : "${lib.makeBinPath [ jre_headless ]}"
  '';

  meta = with lib; {
    description = "A static code analysis tool for Kotlin";
    homepage = "https://detekt.dev/";
    license = licenses.asl20;
    platforms = jre_headless.meta.platforms;
    maintainers = with maintainers; [ SubhrajyotiSen ];
  };
}
