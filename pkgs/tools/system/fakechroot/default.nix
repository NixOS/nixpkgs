{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "fakechroot-${version}";
  version = "2.17.2";

  src = fetchurl {
    url = "https://github.com/dex4er/fakechroot/archive/${version}.tar.gz";
    sha256 = "0z4cxj4lb8cfb63sw82dbc31hf082fv3hshbmhk49cqkc0f673q3";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/dex4er/fakechroot;
    description = "Give a fake chroot environment through LD_PRELOAD";
    license = licenses.lgpl21;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };

}
