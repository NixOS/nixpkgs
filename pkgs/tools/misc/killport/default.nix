{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "killport";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eyRI4ZVp9HPMvpzyV9sQdh2r966pCdyUPnEhxGkzH3Q=";
  };

  cargoHash = "sha256-QQ43dT9BTu7qCzpnTGKzlVL6jKDXofXStYWYNLHSuVs=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  meta = with lib; {
    description = "Command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = licenses.mit;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "killport";
  };
}
