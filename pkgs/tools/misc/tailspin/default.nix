{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = "refs/tags/${version}";
    hash = "sha256-yzG8wFTd4DYnmd+fbBdjZ0fr1iEoL4ZqXr59kX/a0Gs=";
  };

  cargoHash = "sha256-v6aOPfQyxqaoxKvT7ak91GvL68h88WfNjlnyU1vH/kY=";

  meta = with lib; {
    description = "A log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "spin";
  };
}
