{ lib, stdenv, fetchFromGitHub, unzip, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "detekt";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "detekt";
    repo = "detekt";
    rev = "v${version}";
    sha256 = "08jbnn3q3c7vp6jmj3gz67d5v9jlgd9f3dr706cbk8q2v9719gqh";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  preBuild = ''
    export JAVA_HOME=${jre_headless}
  '';

  installPhase = ''
    ./gradlew :detekt-cli:distZip
    mkdir $out
    unzip detekt-cli/build/distributions/detekt-cli-1.22.0.zip -d $out
    mv $out/detekt-cli-${version}/* $out
    rm -rf $out/detekt-cli-${version}
  '';

  postFixup = ''
    wrapProgram $out/bin/detekt-cli --prefix PATH : "${lib.makeBinPath [ jre_headless ]}"
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
