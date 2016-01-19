{ stdenv, fetchurl, unzip, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "hyperleveldb-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/rescrv/HyperLevelDB/archive/releases/${version}.zip";
    sha256 = "0m5fwl9sc7c6m2zm3zjlxxg7f602gnaryikxgflahhdccdvvr56y";
  };

  buildInputs = [ unzip autoreconfHook ];

  meta = with stdenv.lib; {
    description = ''A fork of LevelDB intended to meet the needs of
        HyperDex while remaining compatible with LevelDB.'';
    homepage = https://github.com/rescrv/HyperLevelDB;
    license = licenses.bsd3;
  };
}
