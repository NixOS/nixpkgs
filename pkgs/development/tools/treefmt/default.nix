{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-PALt0tSCYbViC1RHrri0IiD4TUjMnkIwgd3Pe+K9i3Q=";
  };

  cargoSha256 = "sha256-MkjLAaktc0A0yJqixpgnrn8NOHVmcaQL65L0TvrEPRg=";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = lib.teams.numtide.members;
  };
}
