{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  caps,
}:

stdenv.mkDerivation rec {
  pname = "alsaequal";
  version = "0.6";

  src = fetchurl {
    url = "https://thedigitalmachine.net/tools/alsaequal-${version}.tar.bz2";
    sha256 = "1w3g9q5z3nrn3mwdhaq6zsg0jila8d102dgwgrhj9vfx58apsvli";
  };

  buildInputs = [ alsa-lib ];

  makeFlags = [ "DESTDIR=$(out)" ];

  # Borrowed from Arch Linux's AUR
  patches = [
    # Adds executable permissions to resulting libraries
    # and changes their destination directory from "usr/lib/alsa-lib" to "lib/alsa-lib" to better align with nixpkgs filesystem hierarchy.
    ./makefile.patch
    # Fixes control port check, which resulted in false error.
    ./false_error.patch
    # Fixes name change of an "Eq" to "Eq10" method in version 9 of caps library.
    ./caps_9.x.patch
  ];

  postPatch = ''
    sed -i 's#/usr/lib/ladspa/caps\.so#${caps}/lib/ladspa/caps\.so#g' ctl_equal.c pcm_equal.c
  '';

  preInstall = ''
    mkdir -p "$out/lib/alsa-lib"
  '';

  meta = with lib; {
    description = "Real-time adjustable equalizer plugin for ALSA";
    homepage = "https://thedigitalmachine.net/alsaequal.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ymeister ];
  };
}
