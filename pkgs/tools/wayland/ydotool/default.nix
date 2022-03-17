{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, scdoc }:

stdenv.mkDerivation rec {
  pname = "ydotool";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ReimuNotMoe";
    repo = "ydotool";
    rev = "v${version}";
    sha256 = "sha256-maXXGCqB8dkGO8956hsKSwM4HQdYn6z1jBFENQ9sKcA=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    scdoc
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Generic Linux command-line automation tool";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ willibutz kraem ];
    platforms = with platforms; linux;
  };
}
