{ stdenv, fetchurl, jre, makeWrapper }:
stdenv.mkDerivation {
  name = "hbase-0.98.8";
  src = fetchurl {
    url = http://mirror.gopotato.co.uk/apache/hbase/stable/hbase-0.98.8-hadoop2-bin.tar.gz;
    sha256 = "0nvxaqpw8v2hg6mn2p2zxj3y6r4dj4xzxmp8rfmv6m6algn5apv6";
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
