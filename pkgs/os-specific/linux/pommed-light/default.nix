{
  stdenv
, fetchurl
, pciutils
, confuse
, alsaLib
, audiofile
, pkgconfig
, zlib
, eject
}:

stdenv.mkDerivation rec {
  pkgname = "pommed-light";
  version = "1.51lw";
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "https://github.com/bytbox/${pkgname}/archive/v${version}.tar.gz";

    sha256 = "11wi17bh2br1hp8gmq40b1hm5drm6h969505f7432zam3cm8mc8q";
  };

  postPatch = ''
    substituteInPlace pommed.conf.mactel --replace /usr $out
    substituteInPlace pommed.conf.pmac --replace /usr $out
    substituteInPlace pommed/beep.h --replace /usr $out
    substituteInPlace pommed/cd_eject.c --replace /usr/bin/eject ${eject}/bin/eject
  '';

  buildInputs = [
    pciutils
    confuse
    alsaLib
    audiofile
    pkgconfig
    zlib
    eject
  ];

  installPhase = ''
    install -Dm755 pommed/pommed $out/bin/pommed
    install -Dm644 pommed.conf.mactel $out/etc/pommed.conf.mactel
    install -Dm644 pommed.conf.pmac $out/etc/pommed.conf.pmac

    # Man page
    install -Dm644 pommed.1 $out/share/man/man1/pommed.1

    # Sounds
    install -Dm644 pommed/data/goutte.wav $out/share/pommed/goutte.wav
    install -Dm644 pommed/data/click.wav $out/share/pommed/click.wav
  '';

  meta = {
    description = "A trimmed version of the pommed hotkey handler for MacBooks";
    longDescription = ''
      This is a stripped-down version of pommed with client, dbus, and
      ambient light sensor support removed, optimized for use with dwm
      and the like.
    '';
    homepage = https://github.com/bytbox/pommed-light;
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.gpl2;
  };
}
