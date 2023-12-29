{ lib, stdenv, fetchFromGitHub, jdk8, ant, makeWrapper, jre8 }:

let jdk = jdk8; jre = jre8; in
stdenv.mkDerivation rec {
  pname = "ili2c";
  version = "5.1.1";

  nativeBuildInputs = [ ant jdk makeWrapper ];

  src = fetchFromGitHub {
    owner = "claeis";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-FHhx+f253+UdbFjd2fOlUY1tpQ6pA2aVu9CBSwUVoKQ=";
  };

  buildPhase = "ant jar";

  installPhase =
    ''
      mkdir -p $out/share/${pname}
      cp $build/build/source/build/jar/ili2c.jar $out/share/${pname}

      mkdir -p $out/bin
      makeWrapper ${jre}/bin/java $out/bin/ili2c \
        --add-flags "-jar $out/share/${pname}/ili2c.jar"
    '';

  meta = with lib; {
    description = "The INTERLIS Compiler";
    longDescription = ''
      Checks the syntactical correctness of an INTERLIS data model.
    '';
    homepage = "https://www.interlis.ch/downloads/ili2c";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
    ];
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.das-g ];
    platforms = platforms.linux;
    mainProgram = "ili2c";
  };
}
