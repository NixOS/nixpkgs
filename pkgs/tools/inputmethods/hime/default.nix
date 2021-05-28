{
stdenv, fetchFromGitHub, pkgconfig, which, gtk2, gtk3, qt4, qt5, libXtst, lib,
enableChewing ? true, libchewing,
enableAnthy ? true, anthy,
}:

stdenv.mkDerivation {
  name = "hime";
  version = "unstable-2020-06-27";

  src = fetchFromGitHub {
    owner = "hime-ime";
    repo = "hime";
    rev = "c89751a58836906e6916355fd037fc74fd7a7a15";
    sha256 = "024w67q0clzxigsrvqbxpiy8firjvrqi7wbkkcapzzhzapv3nm8x";
  };

  nativeBuildInputs = [ which pkgconfig ];
  buildInputs = [ libXtst gtk2 gtk3 qt4 qt5.qtbase ]
    ++ lib.optional enableChewing libchewing
    ++ lib.optional enableAnthy anthy;

  patchPhase = ''
    patchShebangs configure
  '';

  # The configure script already auto-detect libchewing and anthy,
  # so we do not need additional flags for libchewing or anthy
  configureFlags = [ "--disable-lib64" "--disable-qt5-immodule" ];


  meta = with stdenv.lib; {
    homepage      = "http://hime-ime.github.io/";
    downloadPage  = "https://github.com/hime-ime/hime/downloads";
    description   = "A useful input method engine for Asia region";
    license       = licenses.gpl2Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ yanganto ];
  };
}
