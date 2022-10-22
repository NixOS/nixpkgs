{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-+EcqrmjZR8pkBiIXpdJ/KfmTm719lgz7oC9tH7OhJKY=";
  };

  cargoSha256 = "sha256-DXsKUeSmNUIKPsvrLxkg+Kp78rEfjmJQYf2pj1LWW38=";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = lib.teams.numtide.members;
  };
}
