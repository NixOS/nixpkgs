{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, git, guile, curl }:
stdenv.mkDerivation rec {
  pname = "akku";
  version = "1.1.0-unstable-2024-03-03";

  src = fetchFromGitLab {
    owner = "akkuscm";
    repo = "akku";
    rev = "cb996572fe0dbe74a42d2abeafadffaea2bf8ae3";
    sha256 = "sha256-6xqASnFxzz0yE5oJnh15SOB74PVrVkMVwS3PwKAmgks=";
  };


  nativeBuildInputs = [ autoreconfHook pkg-config ];

  # akku calls curl commands
  buildInputs = [ guile curl git ];

  # Use a dummy package index to boostrap Akku
  preBuild = ''
    touch bootstrap.db
  '';

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  meta = with lib; {
    homepage = "https://akkuscm.org/";
    description = "Language package manager for Scheme";
    changelog = "https://gitlab.com/akkuscm/akku/-/raw/v${version}/NEWS.md";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      nagy
      konst-aa
    ];
    mainProgram = "akku";
  };
}
