{ stdenv, fetchFromGitHub, libX11, libXxf86vm, libXext, libXrandr }:

stdenv.mkDerivation rec {
  name = "xcalib-0.10";

  src = fetchFromGitHub {
    owner = "OpenICC";
    repo = "xcalib";
    rev = "f95abc1a551d7c695a8b142c4d9d5035368d482d";
    sha256 = "05fzdjmhiafgi2jf0k41i3nm0837a78sb6yv59cwc23nla8g0bhr";
  };

  buildInputs = [ libX11 libXxf86vm libXext libXrandr ];

  installPhase = ''
    mkdir -p $out/bin
    cp xcalib $out/bin/
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A tiny monitor calibration loader for X and MS-Windows";
    license = licenses.gpl2;
    maintainers = [];
    platforms = platforms.linux;
  };
}
