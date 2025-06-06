{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "anewer";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ysf";
    repo = pname;
    rev = version;
    sha256 = "181mi674354bddnq894yyq587w7skjh35vn61i41vfi6lqz5dy3d";
  };

  cargoSha256 = "sha256-LJ0l5CZM5NqdbCZe4ELkYf9EkKyBxL/LrNmFy+JS6gM=";

  meta = with lib; {
    description = "Append lines from stdin to a file if they don't already exist in the file";
    mainProgram = "anewer";
    homepage = "https://github.com/ysf/anewer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
