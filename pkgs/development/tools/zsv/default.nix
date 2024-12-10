{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  jq,
}:

stdenv.mkDerivation rec {
  pname = "zsv";
  version = "0.3.8-alpha";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    rev = "v${version}";
    hash = "sha256-+6oZvMlfLVTDLRlqOpgdZP2YxT6Zlt13wBMFlryBrXY=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ jq ];

  configureFlags = [
    "--jq-prefix=${jq.lib}"
  ];

  meta = with lib; {
    description = "World's fastest (simd) CSV parser, with an extensible CLI";
    mainProgram = "zsv";
    homepage = "https://github.com/liquidaty/zsv";
    changelog = "https://github.com/liquidaty/zsv/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
