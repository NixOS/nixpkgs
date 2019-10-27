{ stdenv, fetchFromGitHub, pkg-config, xorg, libconfig }:

stdenv.mkDerivation rec {
  pname = "xob";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "florentc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i163avpij8iy04a0wsds237sjqi5dfvi6ny2z8zicnl4crp34xg";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorg.libX11 libconfig ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A lightweight overlay bar for the X Window System";
    longDescription = ''
      A lightweight configurable overlay volume/backlight/progress/anything bar
      for the X Window System. Each time a new value is read on the standard
      input, it is displayed as a tv-like bar over other windows. It then
      vanishes after a configurable amount of time. A value followed by a bang
      '!' is displayed using an alternate color to account for special states
      (e.g. muted audio). There is also support for overflows (when the value
      exceeds the maximum).
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
