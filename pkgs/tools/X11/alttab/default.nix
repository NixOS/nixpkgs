{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, ronn, libpng, uthash
, xorg }:

stdenv.mkDerivation rec {
  version = "1.5.0";

  pname = "alttab";

  src = fetchFromGitHub {
    owner = "sagb";
    repo = pname;
    rev = "v${version}";
    sha256 = "026xd1bkg10fj2q1n6xx797xk1grpby25qj1pnw2lp4f3vc19qn6";
  };

  nativeBuildInputs = [ 
    autoconf
    automake
    pkgconfig
    ronn
  ];

  preConfigure = "./bootstrap.sh";

  buildInputs = [
    libpng
    uthash
    xorg.libX11
    xorg.libXft
    xorg.libXmu
    xorg.libXpm
    xorg.libXrandr
    xorg.libXrender
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/sagb/alttab";
    description = "X11 window switcher designed for minimalistic window managers or standalone X11 session";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.sgraf ];
  };
}
