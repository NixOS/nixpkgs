{ stdenv, fetchFromGitHub, libX11, libXScrnSaver, libXext, gnulib
  , autoconf, automake, libtool, gettext, pkgconfig
  , git, perl, texinfo, help2man
}:

stdenv.mkDerivation rec {
  pname = "xprintidle-ng";
  version = "git-2015-09-01";

  src = fetchFromGitHub {
    owner = "taktoa";
    repo = pname;
    rev = "9083ba284d9222541ce7da8dc87d5a27ef5cc592";
    sha256 = "0a5024vimpfrpj6w60j1ad8qvjkrmxiy8w1yijxfwk917ag9rkpq";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "AC_PREREQ([2.62])" "AC_PREREQ([2.63])"
  '';

  nativeBuildInputs = [
    autoconf automake gettext git gnulib
    help2man libtool perl pkgconfig texinfo
  ];

  configurePhase = ''
    ./bootstrap --gnulib-srcdir=${gnulib}
    ./configure --prefix="$out"
  '';

  buildInputs = [
    libX11 libXScrnSaver libXext
  ];

  meta = {
    inherit  version;
    description = ''A command-line tool to print idle time from libXss'';
    homepage = http://taktoa.me/xprintidle-ng/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
