{ stdenv, fetchurl, libX11, gtk, pkgconfig, procps, makeWrapper, ... }:

stdenv.mkDerivation rec {
  name = "xbindkeys-config-${version}";
  version = "0.1.3";

  buildInputs = [ gtk pkgconfig makeWrapper ];

  src = fetchurl {
    url = "mirror://debian/pool/main/x/xbindkeys-config/xbindkeys-config_${version}.orig.tar.gz";
    sha256 = "1rs3li2hyig6cdzvgqlbz0vw6x7rmgr59qd6m0cvrai8xhqqykda";
  };

  hardeningDisable = [ "format" ];

  meta = {
    homepage = https://packages.debian.org/source/xbindkeys-config;
    description = "Graphical interface for configuring xbindkeys";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [benley];
    platforms = with stdenv.lib.platforms; linux;
  };

  patches = [ ./xbindkeys-config-patch1.patch ];

  # killall is dangerous on non-gnu platforms. Use pkill instead.
  postPatch = ''
    substituteInPlace middle.c --replace "killall" "pkill -x"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    gzip -c ${./xbindkeys-config.1} > $out/share/man/man1/xbindkeys-config.1.gz
    cp xbindkeys_config $out/bin/xbindkeys-config
    wrapProgram $out/bin/xbindkeys-config --prefix PATH ":" "${procps}/bin"
  '';
}
