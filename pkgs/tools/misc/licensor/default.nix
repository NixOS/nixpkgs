{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "licensor";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "raftario";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bb6q3jpzdygjcs3apl38zzmgkn22ya5wxlqgmlp0cybqbhpi20s";
  };

  cargoSha256 = "1cvwyj2043vi5905n5126ikwbs3flfgzqkzjnzha0h8in8p3skv1";

  meta = with lib; {
    description = "Write licenses to stdout";
    homepage = "https://github.com/raftario/licensor";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
