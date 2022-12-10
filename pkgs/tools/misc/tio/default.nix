{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, inih, bash-completion }:

stdenv.mkDerivation rec {
  pname = "tio";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${version}";
    hash = "sha256-cRwjg0+p+1u+tdG+skqGWzxwM375P4aUsF4JVGgCXOI=";
  };

  nativeBuildInputs = [ meson ninja pkg-config inih bash-completion ];

  meta = with lib; {
    description = "Serial console TTY";
    homepage = "https://tio.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.unix;
  };
}
