{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  installShellFiles,
  pixman,
  xcbutil,
  xcbutilimage,
  libseccomp,
  libjpeg,
  libpng,
  libXpm,
}:

stdenv.mkDerivation rec {
  pname = "xwallpaper";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "stoeckmann";
    repo = "xwallpaper";
    rev = "v${version}";
    sha256 = "sha256-onxneLmXs1rYwpTzcnn+rbDboWVoEQgtGMHx/bMPRa8=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    installShellFiles
  ];
  buildInputs = [
    pixman
    xcbutilimage
    xcbutil
    libseccomp
    libjpeg
    libpng
    libXpm
  ];

  postInstall = ''
    installShellCompletion --zsh _xwallpaper
  '';

  meta = with lib; {
    homepage = "https://github.com/stoeckmann/xwallpaper";
    description = "Utility for setting wallpapers in X";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "xwallpaper";
  };
}
