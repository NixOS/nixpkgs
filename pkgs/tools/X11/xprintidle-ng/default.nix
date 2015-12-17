{ stdenv, fetchFromGitHub, libX11, libXScrnSaver, libXext, gnulib
  , autoconf, automake, libtool, gettext, pkgconfig
  , git, perl, texinfo, help2man
}:
stdenv.mkDerivation rec {
  version = "git-2015-09-01";
  name = "${baseName}-${version}";
  baseName = "xprintidle-ng";

  buildInputs = [
    libX11 libXScrnSaver libXext gnulib
    autoconf automake libtool gettext pkgconfig  git perl 
    texinfo help2man
    ];
  src = fetchFromGitHub {
    owner = "taktoa";
    repo = "${baseName}";
    rev = "9083ba284d9222541ce7da8dc87d5a27ef5cc592";
    sha256 = "0a5024vimpfrpj6w60j1ad8qvjkrmxiy8w1yijxfwk917ag9rkpq";
  };

  configurePhase = ''
    cp -r "${gnulib}" gnulib
    chmod a+rX,u+w -R gnulib
    ./bootstrap --gnulib-srcdir=gnulib
    ./configure --prefix="$out"
  '';

  meta = {
    inherit  version;
    description = ''A command-line tool to print idle time from libXss'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
