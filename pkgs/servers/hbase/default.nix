{ stdenv, fetchurl, jre, makeWrapper }:
stdenv.mkDerivation rec {
  name = "hbase-${version}";
  version = "0.98.19";

  src = fetchurl {
    url = "mirror://apache/hbase/${version}/hbase-${version}-hadoop2-bin.tar.gz";
    sha256 = "0g7y38cw09fydbf4fbs1anyilhfgxpbfs41f0aignli5i3hd1pgx";
  };

  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';
  meta = with stdenv.lib; {
    description = "A distributed, scalable, big data store";
    homepage = https://hbase.apache.org;
    license = licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
