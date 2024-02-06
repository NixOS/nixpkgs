{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vi4X5P9ey6JkASiDFMCrJjnJW4vsw0d+GoItXTLzYzc=";
  };

  cargoHash = "sha256-wcyfe6YWuRKJzI4dhRJr0tWW830oDe8IPhtWk7zn0Cc=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "emplace";
  };
}
