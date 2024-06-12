{ lib, stdenv, fetchFromGitLab, meson, pkg-config, ninja, cairo }:

stdenv.mkDerivation rec {
  pname = "pscircle";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "mildlyparallel";
    repo = "pscircle";
    rev = "v${version}";
    sha256 = "sha256-bqbQBNscNfoqXprhoFUnUQO88YQs9xDhD4d3KHamtG0=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    cairo
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/mildlyparallel/pscircle";
    description = "Visualize Linux processes in a form of a radial tree";
    mainProgram = "pscircle";
    license = licenses.gpl2;
    maintainers = [ maintainers.ldesgoui ];
    platforms = platforms.linux;
  };
}
