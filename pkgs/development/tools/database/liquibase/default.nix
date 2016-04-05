{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liquibase";
  version = "3.4.2";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/${pname}-parent-${version}/${name}-bin.tar.gz";
    sha256 = "1kvxqjz8jmqpmb1clhp2asxmgfk6ynqjir8fldc321v9a5wnqby5";
  };

  buildInputs = [ jre makeWrapper ];

  unpackPhase = ''
    tar xfz ${src}
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib,sdk}
    mv ./* $out/
    wrapProgram $out/liquibase --prefix PATH ":" ${jre}/bin --set LIQUIBASE_HOME $out;
    ln -s $out/liquibase $out/bin/liquibase
  '';

  meta = with stdenv.lib; {
    description = "Version Control for your database";
    homepage = "http://www.liquibase.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
