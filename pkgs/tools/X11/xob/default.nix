{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorg,
  libconfig,
}:

stdenv.mkDerivation rec {
  pname = "xob";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "florentc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x4aafiyd9k4y8cmvn7rgfif3g5s5hhlbj5nz71qsyqg21nn7hrw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
    xorg.libXrender
    libconfig
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "A lightweight overlay bar for the X Window System";
    longDescription = ''
      A lightweight configurable overlay volume/backlight/progress/anything bar
      for the X Window System (and Wayland compositors with XWayland). Each
      time a new value is read on the standard input, it is displayed as a
      tv-like bar over other windows. It then vanishes after a configurable
      amount of time. A value followed by a bang '!' is displayed using an
      alternate color to account for special states (e.g. muted audio). There
      is also support for overflows (when the value exceeds the maximum).
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ florentc ];
    mainProgram = "xob";
  };
}
