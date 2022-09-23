{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "screen-message";
  version = "0.26";

  src = fetchurl {
    url = "mirror://debian/pool/main/s/screen-message/screen-message_${version}.orig.tar.gz";
    sha256 = "sha256-vBKnuXOEQZDACmlNP9wjJ3NbIdixIx7I72a6Nj6pjzc=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ gtk3 ];

  # screen-message installs its binary in $(prefix)/games per default
  makeFlags = [ "execgamesdir=$(out)/bin" ];

  meta = {
    homepage = "https://www.joachim-breitner.de/en/projects#screen-message";
    description = "Displays a short text fullscreen in an X11 window";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.fpletz ];
    mainProgram = "sm";
    platforms = lib.platforms.unix;
  };
}
