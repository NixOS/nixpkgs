{ stdenv, fetchFromGitHub, jdk, ant, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ili2c";
  version = "5.0.8";

  nativeBuildInputs = [ ant jdk makeWrapper ];

  src = fetchFromGitHub {
    owner = "claeis";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1yhsyh940kb33y2n6xl7zhf0f6q0nrxbyg6c4g5n2imllpn54sgi";
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

  meta = with stdenv.lib; {
    description = "The INTERLIS Compiler";
    longDescription = ''
      Checks the syntactical correctness of an INTERLIS data model.
    '';
    homepage = "https://www.interlis.ch/downloads/ili2c";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.das-g ];
    platforms = platforms.linux;
  };
}
