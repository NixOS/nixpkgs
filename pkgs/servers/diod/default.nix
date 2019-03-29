{ stdenv, fetchurl, munge, lua,
  libcap, perl, ncurses
}:

stdenv.mkDerivation rec {
  name = "diod-${version}";
  version = "1.0.24";

  src = fetchurl {
    url = "https://github.com/chaos/diod/releases/download/${version}/${name}.tar.gz";
    sha256 = "17wckwfsqj61yixz53nwkc35z66arb1x3napahpi64m7q68jn7gl";
  };

  postPatch = ''
    substituteInPlace diod/xattr.c --replace attr/xattr.h sys/xattr.h
  '';

  buildInputs = [ munge lua libcap perl ncurses ];

  meta = with stdenv.lib; {
    description = "An I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = with maintainers; [ rnhmjoj rickynils ];
    platforms   = platforms.linux;
    license     = licenses.gpl2Plus;
  };
}
