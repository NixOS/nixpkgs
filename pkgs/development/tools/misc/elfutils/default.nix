{stdenv, fetchurl, m4}:

stdenv.mkDerivation rec {
  name = "elfutils-0.148";
  
  src = fetchurl {
    urls = [
      "https://fedorahosted.org/releases/e/l/elfutils/0.143/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1nl7x2gidd2i048yjlvyzhpbca9793z435cw8bsircjxfi5gmswa";
  };

  buildInputs = [m4];
  
  dontAddDisableDepTrack = true;

  meta = {
    homepage = https://fedorahosted.org/elfutils/;
  };
}
