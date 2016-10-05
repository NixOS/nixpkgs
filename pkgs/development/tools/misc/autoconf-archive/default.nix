{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "autoconf-archive-${version}";
  version = "2016.09.16";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "10mxz9hfnfz66m1l9s28sbyfb9a04akz92wkyv9blhpq6p9fzwp8";
  };

  buildInputs = [ xz ];

  meta = with stdenv.lib; {
    description = "Archive of autoconf m4 macros";
    homepage = http://www.gnu.org/software/autoconf-archive/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
