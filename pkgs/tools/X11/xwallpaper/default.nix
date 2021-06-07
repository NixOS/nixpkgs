{ lib, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, installShellFiles
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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "stoeckmann";
    repo = "xwallpaper";
    rev = "v${version}";
    sha256 = "1bpymspnllbscha8j9y67w9ck2l6yv66zdbknv8s13hz5qi1ishk";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook installShellFiles ];
  buildInputs = [ pixman xcbutilimage xcbutil libseccomp libjpeg libpng libXpm ];

  postInstall = ''
    installShellCompletion --zsh _xwallpaper
  '';

  meta = with lib; {
    homepage = "https://github.com/stoeckmann/xwallpaper";
    description = "Utility for setting wallpapers in X";
    license = licenses.isc;
    maintainers = with maintainers; [ ivar ];
    platforms = platforms.linux;
  };
}
