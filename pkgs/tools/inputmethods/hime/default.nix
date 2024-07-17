{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  gtk2,
  gtk3,
  qt5,
  libXtst,
  lib,
  libchewing,
  unixtools,
  anthy,
}:

stdenv.mkDerivation rec {
  pname = "hime";
  version = "0.9.11";

  src = fetchFromGitHub {
    repo = pname;
    owner = "hime-ime";
    rev = "v${version}";
    sha256 = "sha256-fCqet+foQjI+LpTQ/6Egup1GzXELlL2hgbh0dCKLwPI=";
  };

  nativeBuildInputs = [
    which
    pkg-config
    unixtools.whereis
  ];
  buildInputs = [
    libXtst
    gtk2
    gtk3
    qt5.qtbase
    libchewing
    anthy
  ];

  preConfigure = "patchShebangs configure";
  configureFlags = [
    "--disable-lib64"
    "--disable-qt5-immodule"
  ];
  dontWrapQtApps = true;
  postFixup = ''
    hime_rpath=$(patchelf --print-rpath $out/bin/hime)
    patchelf --set-rpath $out/lib/hime:$hime_rpath $out/bin/hime
  '';

  meta = with lib; {
    homepage = "http://hime-ime.github.io/";
    downloadPage = "https://github.com/hime-ime/hime/downloads";
    description = "A useful input method engine for Asia region";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yanganto ];
  };
}
