{ lib, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, pixman
, xcbutil
, xcbutilimage
, libseccomp
, libjpeg
, libpng
, libXpm
}:

stdenv.mkDerivation rec {
  pname = "xwallpaper";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "stoeckmann";
    repo = "xwallpaper";
    rev = "v${version}";
    sha256 = "sha256-WYtbwMFzvJ0Xr84gGoKSofSSnmb7Qn6ioGMOnQOqdII=";
  };

  preConfigure = "./autogen.sh";

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ pixman xcbutilimage xcbutil libseccomp libjpeg libpng libXpm ];

  meta = with lib; {
    homepage = "https://github.com/stoeckmann/xwallpaper";
    description = "Utility for setting wallpapers in X";
    license = licenses.isc;
    maintainers = with maintainers; [ ivar ];
    platforms = platforms.linux;
  };
}
