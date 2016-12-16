{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liquibase";
  version = "3.5.3";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/${pname}-parent-${version}/${name}-bin.tar.gz";
    sha256 = "04cpnfycv0ms70d70w8ijqp2yacj2svs7v3lk99z1bpq3rzx51gv";
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
    platforms = with platforms; unix;
  };
}
