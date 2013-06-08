{stdenv, fetchurl, gpm, freetype, fontconfig, pkgconfig, ncurses}:
let
  s = # Generated upstream information
  rec {
    baseName="fbterm";
    version="1.7.0";
    name="fbterm-1.7.0";
    hash="0pciv5by989vzvjxsv1jsv4bdp4m8j0nfbl29jm5fwi12w4603vj";
    url="http://fbterm.googlecode.com/files/fbterm-1.7.0.tar.gz";
    sha256="0pciv5by989vzvjxsv1jsv4bdp4m8j0nfbl29jm5fwi12w4603vj";
  };
  buildInputs = [gpm freetype fontconfig pkgconfig ncurses];
in
stdenv.mkDerivation {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };
  inherit buildInputs;
  preConfigure = ''
    sed -e '/ifdef SYS_signalfd/atypedef long long loff_t;' -i src/fbterm.cpp
    sed -e '/install-exec-hook:/,/^[^\t]/{d}; /.NOEXPORT/iinstall-exec-hook:\
    ' -i src/Makefile.in
    export HOME=$PWD;
    export NIX_LDFLAGS="$NIX_LDFLAGS -lfreetype"
  '';
  meta = {
    inherit (s) version;
    description = "Framebuffer terminal emulator";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
