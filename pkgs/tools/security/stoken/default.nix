{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig
, libxml2, nettle
, withGTK3 ? true, gtk3 }:

stdenv.mkDerivation rec {
  pname = "stoken";
  version = "0.92";
  src = fetchFromGitHub {
    owner = "cernekee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q7cv8vy5b2cslm57maqb6jsm7s4rwacjyv6gplwp26yhm38hw7y";
  };

  preConfigure = ''
    aclocal
    libtoolize --automake --copy
    autoheader
    automake --add-missing --copy
    autoconf
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf automake libtool
    libxml2 nettle
  ] ++ stdenv.lib.optional withGTK3 gtk3;

  meta = with stdenv.lib; {
    description = "Software Token for Linux/UNIX";
    homepage = https://github.com/cernekee/stoken;
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
