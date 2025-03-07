{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "killport";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eyRI4ZVp9HPMvpzyV9sQdh2r966pCdyUPnEhxGkzH3Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rJgbTJGRZNev5hPyH7NuRB0Utpdbh6zoYQL4rbfhn2Y=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  meta = with lib; {
    description = "Command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = licenses.mit;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "killport";
  };
}
