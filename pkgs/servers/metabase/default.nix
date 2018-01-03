{ pkgs, stdenv, lib, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "metabase-${version}";
  version = "0.27.2";

  jar = fetchurl {
    url = "http://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "1xsd6k362kajbf6sw0pb7zkd686i350fqqin858a5mmjlm5jkci7";
  };

  buildInputs = [ makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/share/java
    ln -s $jar $out/share/java/metabase.jar
    makeWrapper ${jre}/bin/java $out/bin/metabase --add-flags "-jar $out/share/java/metabase.jar"
  '';

  meta = with lib; {
    description = "Metabase is the easy, open source way for everyone in your company to ask questions and learn from data.";
    homepage = https://metabase.com;
    license = licenses.agpl3;
    maintainers = with maintainers; [ schneefux ];
  };
}
