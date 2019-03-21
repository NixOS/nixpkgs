{ stdenv
, fetchFromGitHub
, pciutils
, libconfuse
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

  src = fetchFromGitHub {
    owner = "bytbox";
    repo = pkgname;
    rev = "v${version}";
    sha256 = "18fvdwwhcl6s4bpf2f2i389s71c8k4g0yb81am9rdddqmzaw27iy";
  };

  postPatch = ''
    substituteInPlace pommed.conf.mactel --replace /usr $out
    substituteInPlace pommed.conf.pmac --replace /usr $out
    substituteInPlace pommed/beep.h --replace /usr $out
    substituteInPlace pommed/cd_eject.c --replace /usr/bin/eject ${eject}/bin/eject
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    pciutils
    libconfuse
    alsaLib
    audiofile
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
