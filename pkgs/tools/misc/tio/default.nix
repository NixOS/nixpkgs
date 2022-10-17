{ lib, stdenv, fetchFromGitHub, meson, ninja, cmake, pkg-config, inih, bash-completion }:

stdenv.mkDerivation rec {
  pname = "tio";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${version}";
    hash = "sha256-1GKwJylC57es2zM0ON3y4DLgJ7Q6bDYZW/L49U8GBLo=";
  };

  nativeBuildInputs = [ meson ninja cmake pkg-config inih bash-completion ];

  meta = with lib; {
    description = "Serial console TTY";
    homepage = "https://tio.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.unix;
  };
}
