{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = "refs/tags/${version}";
    hash = "sha256-Uqo47g0AXyRNFb1RmVVJzdFI2g1Oakx85Sg+zIN5B2A=";
  };

  cargoHash = "sha256-0ROLrdS3oBZuh+nXW9mTS2Jn/D+iLAUaYqhKvmKAPTo=";

  meta = with lib; {
    description = "A log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "spin";
  };
}
