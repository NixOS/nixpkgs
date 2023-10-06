{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, inih, bash-completion }:

stdenv.mkDerivation rec {
  pname = "tio";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${version}";
    hash = "sha256-cYCkf9seaWcjrW0aDz+5FexfnTtiO3KQ1aX4OgG62Ug=";
  };

  strictDeps = true;

  buildInputs = [ inih ];

  nativeBuildInputs = [ meson ninja pkg-config bash-completion ];

  meta = with lib; {
    description = "Serial console TTY";
    homepage = "https://tio.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.unix;
  };
}
