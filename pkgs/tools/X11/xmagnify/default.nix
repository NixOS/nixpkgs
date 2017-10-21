{ stdenv, fetchFromGitLab, libX11, xproto }:

stdenv.mkDerivation rec {
  name = "xmagnify-0.1.0";

  src = fetchFromGitLab {
    owner = "amiloradovsky";
    repo = "magnify";
    rev = "0.1.0";  # 56da280173e9d0bd7b3769e07ba485cb4db35869
    sha256 = "1ngnp5f5zl3v35vhbdyjpymy6mwrs0476fm5nd7dzkba7n841jdh";
  };

  prePatch = ''substituteInPlace ./Makefile --replace /usr $out'';

  buildInputs = [ libX11 xproto ];

  meta = with stdenv.lib; {
    description = "Tiny screen magnifier for X11";
    homepage = https://gitlab.com/amiloradovsky/magnify;
    license = licenses.mit;  # or GPL2+, optionally
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = platforms.all;
  };
}
