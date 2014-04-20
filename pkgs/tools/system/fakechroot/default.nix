{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "fakechroot-${version}";
  version = "2.17.2";

  src = fetchurl {
    url = "https://github.com/dex4er/fakechroot/archive/${version}.tar.gz";
    md5 = "e614f62972efa4654fc780ae7e4affad";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/dex4er/fakechroot;
    description = "Give a fake chroot environment through LD_PRELOAD";
    license = licenses.lgpl21;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };

}
