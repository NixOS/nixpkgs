{stdenv, fetchFromGitHub, linuxHeaders}:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "gfxtablet-uinput-driver-${version}";

  buildInputs = [
    linuxHeaders
  ];

  src = fetchFromGitHub {
    owner = "rfc2822";
    repo = "GfxTablet";
    rev = "android-app-${version}";
    sha256 = "1i2m98yypfa9phshlmvjlgw7axfisxmldzrvnbzm5spvv5s4kvvb";
  };

  preBuild = ''cd driver-uinput'';

  installPhase = ''
    mkdir -p "$out/bin"
    cp networktablet "$out/bin"
    mkdir -p "$out/share/doc/gfxtablet/"
    cp ../*.md "$out/share/doc/gfxtablet/"
  '';

  meta = {
    description = ''Uinput driver for Android GfxTablet tablet-as-input-device app'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
