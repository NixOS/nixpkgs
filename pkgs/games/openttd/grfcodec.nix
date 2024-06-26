{
  stdenv,
  lib,
  fetchFromGitHub,
  boost,
  cmake,
  git,
}:

stdenv.mkDerivation rec {
  pname = "openttd-grfcodec";
  version = "unstable-2021-03-10";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "grfcodec";
    rev = "045774dee7cab1a618a3e0d9b39bff78a12b6efa";
    sha256 = "0b4xnnkqc01d3r834lhkq744ymar6c8iyxk51wc4c7hvz0vp9vmy";
  };

  buildInputs = [ boost ];
  nativeBuildInputs = [
    cmake
    git
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a grfcodec grfid grfstrip nforenum $out/bin/
  '';

  meta = with lib; {
    description = "Low-level (dis)assembler and linter for OpenTTD GRF files";
    homepage = "http://openttd.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
