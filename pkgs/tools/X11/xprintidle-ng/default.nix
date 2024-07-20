{ lib
, stdenv
, fetchFromGitHub
, libX11
, libXScrnSaver
, libXext
, gnulib
, autoconf
, automake
, libtool
, gettext
, pkg-config
, git
, perl
, texinfo
, help2man
}:

stdenv.mkDerivation rec {
  pname = "xprintidle-ng";
  version = "unstable-2015-09-01";

  src = fetchFromGitHub {
    owner = "taktoa";
    repo = pname;
    rev = "9083ba284d9222541ce7da8dc87d5a27ef5cc592";
    sha256 = "0a5024vimpfrpj6w60j1ad8qvjkrmxiy8w1yijxfwk917ag9rkpq";
  };

  patches = [
    ./fix-config_h-includes-should-be-first.patch
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "AC_PREREQ([2.62])" "AC_PREREQ([2.64])"
  '';

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    git
    gnulib
    help2man
    libtool
    perl
    pkg-config
    texinfo
  ];

  configurePhase = ''
    ./bootstrap --gnulib-srcdir=${gnulib}
    ./configure --prefix="$out"
  '';

  buildInputs = [
    libX11
    libXScrnSaver
    libXext
  ];

  meta = {
    inherit version;
    description = "Command-line tool to print idle time from libXss";
    homepage = "https://github.com/taktoa/xprintidle-ng";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    mainProgram = "xprintidle-ng";
  };
}
