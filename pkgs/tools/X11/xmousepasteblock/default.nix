{ xorg, lib, stdenv, libev, fetchFromGitHub, pkg-config }:

stdenv.mkDerivation rec {
  pname = "xmousepasteblock";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "milaq";
    repo = "XMousePasteBlock";
    sha256 = "0vidckfp277cg2gsww8a8q5b18m10iy4ppyp2qipr89771nrcmns";
    rev = version;
  };
  makeFlags = "PREFIX=$(out)";
  buildInputs = with xorg; [ libX11 libXext libXi libev ];
  nativeBuildInputs = [ pkg-config ];
  meta = with lib; {
    description = "Middle mouse button primary X selection/clipboard paste disabler";
    homepage = "https://github.com/milaq/XMousePasteBlock";
    license = lib.licenses.gpl2;
    maintainers = [ maintainers.petercommand ];
  };
}
