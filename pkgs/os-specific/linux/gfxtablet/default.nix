{stdenv, fetchgit, linuxHeaders}:
let
  s = # Generated upstream information
  rec {
    version="git-2013-10-21";
    name = "gfxtablet-uinput-driver-${version}";
    rev = "c4e337ae0b53a8ccdfe11b904ff129714bd25ec4";
    sha256 = "19d96r2vw9xv82fnfwdyyyf0fja6n06mgg14va996knsn2x5l4la";
    url = "https://github.com/rfc2822/GfxTablet.git";
  };
  buildInputs = [
    linuxHeaders
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchgit {
    inherit (s) url sha256 rev;
  };
  preBuild = ''cd driver-uinput'';
  installPhase = ''
    mkdir -p "$out/bin"
    cp networktablet "$out/bin"
    mkdir -p "$out/share/doc/gfxtablet/"
    cp ../*.md "$out/share/doc/gfxtablet/"
  '';
  meta = {
    inherit (s) version;
    description = ''Uinput driver for Android GfxTablet tablet-as-input-device app'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
