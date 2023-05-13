{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-71P0ESPLTUq8z0mSU4v8KmS069DNUi5fPHz01Kg3aKg=";
  };

  cargoHash = "sha256-XAelHpTVvz+jsDzfB+jsEuUdB0hN7c+hVDvCyOixx9E=";

  patches = [
    # fixes failing tests due to outdated snapshots
    (fetchpatch {
      name = "test-cli-udpate-stdout.patch";
      url = "https://github.com/loichyan/nerdfix/commit/4070f9e894337ca7d3f7641258428ad6d7cd6332.patch";
      hash = "sha256-oDuHKgoMcOaO1mtBbT1Uwn5ZUp/FvqsD4S+A1LdOhcE=";
    })
  ];

  meta = with lib; {
    description = "Nerdfix helps you to find/fix obsolete nerd font icons in your project";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
