{ stdenv, fetchurl, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "hbase";
  version = "0.98.24";

  src = fetchurl {
    url = "mirror://apache/hbase/${version}/hbase-${version}-hadoop2-bin.tar.gz";
    sha256 = "0kz72wqsii09v9hxkw10mzyvjhji5sx3l6aijjalgbybavpcxglb";
  };

  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';
  meta = with stdenv.lib; {
    description = "A distributed, scalable, big data store";
    homepage = "https://hbase.apache.org";
    license = licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
