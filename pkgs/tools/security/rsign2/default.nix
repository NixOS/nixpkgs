{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "rsign2";
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ono7cKXccYMmkrlsJ+Z85w8z0fEduuEQhRlHQQk0vzU=";
  };

  cargoHash = "sha256-Yuf4iTWGQp/1ZUVqaR0tKfFxKJ9JEmMLq1LL7gwf6w0=";

  meta = with lib; {
    description = "A command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rsign";
  };
}
