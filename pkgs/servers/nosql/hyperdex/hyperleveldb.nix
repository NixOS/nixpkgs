{ stdenv, fetchurl, unzip, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "hyperleveldb-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/rescrv/HyperLevelDB/archive/releases/${version}.zip";
    sha256 = "0xrzhwkrm7f2wz3jn4iqn1dim2pmgjhmpb1fy23fwa06v0q18hw8";
  };
  buildInputs = [ unzip autoconf automake libtool ];
  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    description = ''A fork of LevelDB intended to meet the needs of
        HyperDex while remaining compatible with LevelDB.'';
    homepage = https://github.com/rescrv/HyperLevelDB;
    license = licenses.bsd3;
  };
}
