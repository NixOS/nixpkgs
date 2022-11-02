{ lib, stdenv, fetchFromGitHub, meson, ninja, cmake, pkg-config, inih, bash-completion }:

stdenv.mkDerivation rec {
  pname = "tio";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${version}";
    hash = "sha256-BjA9Zl6JcgDxTj4KPiWItSq9XuX9FJkpZnhdMBGZQpQ=";
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
