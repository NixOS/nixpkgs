{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, pciutils
, libconfuse
, alsa-lib
, audiofile
, pkg-config
, zlib
, eject
}:

stdenv.mkDerivation rec {
  pname = "pommed-light";
  version = "1.51lw";

  src = fetchFromGitHub {
    owner = "bytbox";
    repo = "pommed-light";
    rev = "v${version}";
    sha256 = "18fvdwwhcl6s4bpf2f2i389s71c8k4g0yb81am9rdddqmzaw27iy";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/bytbox/pommed-light/pull/38
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/bytbox/pommed-light/commit/5848b49b45a9c3ab047ebd17deb2162daab1e0b8.patch";
      sha256 = "15rsq2i4rqp4ssab20486a1wgxi2cp87b7nxyk9h23gdwld713vf";
    })
  ];

  postPatch = ''
    substituteInPlace pommed.conf.mactel --replace /usr $out
    substituteInPlace pommed.conf.pmac --replace /usr $out
    substituteInPlace pommed/beep.h --replace /usr $out
    substituteInPlace pommed/cd_eject.c --replace /usr/bin/eject ${eject}/bin/eject
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pciutils
    libconfuse
    alsa-lib
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
    mainProgram = "pommed";
    longDescription = ''
      This is a stripped-down version of pommed with client, dbus, and
      ambient light sensor support removed, optimized for use with dwm
      and the like.
    '';
    homepage = "https://github.com/bytbox/pommed-light";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl2;
  };
}
