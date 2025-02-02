{ lib, stdenv, fetchFromGitHub, libX11, libXxf86vm, libXext, libXrandr }:

stdenv.mkDerivation rec {
  pname = "xcalib";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "OpenICC";
    repo = "xcalib";
    rev = version;
    sha256 = "05fzdjmhiafgi2jf0k41i3nm0837a78sb6yv59cwc23nla8g0bhr";
  };

  buildInputs = [ libX11 libXxf86vm libXext libXrandr ];

  installPhase = ''
    mkdir -p $out/bin
    cp xcalib $out/bin/
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A tiny monitor calibration loader for X and MS-Windows";
    license = licenses.gpl2Plus;
    maintainers = [];
    platforms = platforms.linux;
    mainProgram = "xcalib";
  };
}
