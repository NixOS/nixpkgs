{ stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, pixman
, xcbutil
, xcbutilimage
, libjpeg
, libpng
, libXpm
}:

stdenv.mkDerivation rec {
  pname = "xwallpaper";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "stoeckmann";
    repo = "xwallpaper";
    rev = "v${version}";
    sha256 = "121ai4dc0v65qk12gn9w62ixly8hc8a5qrygkbb82vy8ck4jqxj7";
  };

  preConfigure = "./autogen.sh";

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ pixman xcbutilimage xcbutil libjpeg libpng libXpm ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/stoeckmann/xwallpaper";
    description = "Utility for setting wallpapers in X";
    license = licenses.isc;
    maintainers = with maintainers; [ ivar ];
    platforms = platforms.linux;
  };
}
