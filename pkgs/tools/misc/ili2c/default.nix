{ stdenv, fetchFromGitHub, jdk, ant, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ili2c";
  version = "5.0.0";

  nativeBuildInputs = [ ant jdk makeWrapper ];

  src = fetchFromGitHub {
    owner = "claeis";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0xps2343d5gdr2aj8j3l4cjq4k9zbxxlhnp8sjlhxh1wdczxlwx6";
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
