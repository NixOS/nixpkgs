{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = version;
    hash = "sha256-STQtWLrRS76sowGOBLZqeE8bYcDUjI5ErQD3D7z98M8=";
  };

  cargoHash = "sha256-gNyegmr7Iv7dRe/bCwxLbhVkhex0D9ylF5Eulix26tg=";

  meta = with lib; {
    description = "Log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tspin";
  };
}
