{ stdenv, fetchurl, jre, makeWrapper }:
stdenv.mkDerivation rec {
  name = "hbase-${version}";
  version = "0.98.13";

  src = fetchurl {
    url = "mirror://apache/hbase/${version}/hbase-${version}-hadoop2-bin.tar.gz";
    sha256 = "1av81nnnwivxf5ha6x9qrr2afl5sbyskl07prv0rdac954xmgg8n";
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
