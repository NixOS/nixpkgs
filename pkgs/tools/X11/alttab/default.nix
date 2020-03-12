{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, ronn, libpng, uthash
, xorg }:

stdenv.mkDerivation rec {
  version = "1.4.0";

  pname = "alttab";

  src = fetchFromGitHub {
    owner = "sagb";
    repo = pname;
    rev = "v${version}";
    sha256 = "028ifp54yl3xq5mj2ww9baga8p56nmrx4ypvj8k35akcaxdpyga9";
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

  enableParallelBuild = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/sagb/alttab;
    description = "X11 window switcher designed for minimalistic window managers or standalone X11 session";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.sgraf ];
  };
}
