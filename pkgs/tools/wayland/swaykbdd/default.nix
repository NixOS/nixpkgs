{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  json_c,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "swaykbdd";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = "swaykbdd";
    rev = "v${version}";
    sha256 = "sha256-FtXmn5Lf0PhL99xGl/SHWNaE6vAMOF2Ok4xVJT2Bf/s=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ json_c ];

  meta = with lib; {
    description = "Per-window keyboard layout for Sway";
    homepage = "https://github.com/artemsen/swaykbdd";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky ];
    platforms = platforms.linux;
    mainProgram = "swaykbdd";
  };
}
