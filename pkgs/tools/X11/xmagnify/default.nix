{ lib, stdenv, fetchFromGitLab, libX11, xorgproto }:

stdenv.mkDerivation rec {
  pname = "xmagnify";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "amiloradovsky";
    repo = "magnify";
    rev = version;
    sha256 = "1ngnp5f5zl3v35vhbdyjpymy6mwrs0476fm5nd7dzkba7n841jdh";
  };

  prePatch = "substituteInPlace ./Makefile --replace /usr $out";

  buildInputs = [ libX11 xorgproto ];

  meta = with lib; {
    description = "Tiny screen magnifier for X11";
    homepage = "https://gitlab.com/amiloradovsky/magnify";
    license = licenses.mit;  # or GPL2+, optionally
    maintainers = with maintainers; [ amiloradovsky ];
    mainProgram = "magnify";
    platforms = platforms.all;
  };
}
