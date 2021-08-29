{ lib, stdenv, fetchFromGitHub, meson, ninja, json_c, pkg-config }:

stdenv.mkDerivation rec {
  pname = "swaykbdd";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = "swaykbdd";
    rev = "v${version}";
    sha256 = "101mbf7pvm4ykmkh29g5xswrzdhdwq0rslzxqqfd5ksf1fphzgxd";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ json_c ];

  meta = with lib; {
    description = "Per-window keyboard layout for Sway";
    homepage = "https://github.com/artemsen/swaykbdd";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky ];
    platforms = platforms.linux;
  };
}
