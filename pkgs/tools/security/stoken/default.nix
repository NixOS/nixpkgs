{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config
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

  strictDeps = true;
  nativeBuildInputs = [ pkg-config autoconf automake libtool ];
  buildInputs = [
    libxml2 nettle
  ] ++ lib.optional withGTK3 gtk3;

  meta = with lib; {
    description = "Software Token for Linux/UNIX";
    homepage = "https://github.com/cernekee/stoken";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
