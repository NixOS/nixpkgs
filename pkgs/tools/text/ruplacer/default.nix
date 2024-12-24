{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Zvbb9pQpxbJZi0qcDU6f2jEgavl9cA7gIYU7NRXZ9fc=";
  };

  cargoHash = "sha256-vdq2nEFhvteQEqEZNbSegivvkU6cTxSmZLc6oaxLkwY=";

  meta = {
    description = "Find and replace text in source files";
    mainProgram = "ruplacer";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
  };
}
