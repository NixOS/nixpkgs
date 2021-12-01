{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "tio";
  version = "1.32";

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${version}";
    hash = "sha256-m8GgS7bv1S7KXoP7tYaTaXnjF1lBz4s0ThHqOU5tmFM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Serial console TTY";
    homepage = "https://tio.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.unix;
  };
}
