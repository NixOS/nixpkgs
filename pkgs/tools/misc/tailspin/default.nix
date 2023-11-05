{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = "refs/tags/${version}";
    hash = "sha256-NGPwdTkgzowdchUjuoJ9iVrkmAjXvyijHmUfb5cAUKY=";
  };

  cargoHash = "sha256-Pi8JiToF56a6zaUpGTAF6Bw8W8elSzLQimfMDua83Nk=";

  meta = with lib; {
    description = "A log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tspin";
  };
}
