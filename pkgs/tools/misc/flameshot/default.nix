{ stdenv, fetchFromGitHub, qtbase, qmake, qttools }:

stdenv.mkDerivation rec {
  name = "flameshot-${version}";
  version = "0.5.0";

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase ];

  qmakeFlags = [
    # flameshot.pro assumes qmake is being run in a git checkout and uses it
    # to determine the version being built. Let's replace that.
    "VERSION=${version}"
    "PREFIX=/"
  ];
  patchPhase = ''
    sed -i 's/VERSION =/#VERSION =/g' flameshot.pro
    sed -i 's,USRPATH = /usr/local,USRPATH = /,g' flameshot.pro
  '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  src = fetchFromGitHub {
    owner = "lupoDharkael";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "1fy4il7rdj294l9cs642hx23bry25j9phn37274r2b87hwzy1rrv";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = https://github.com/lupoDharkael/flameshot;
    maintainers = [ maintainers.scode ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
