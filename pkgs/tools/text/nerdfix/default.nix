{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-HNd2wx1nUzPPs+wQBU4FOgDBq4mcyigEPtGpT44VPzo=";
  };

  cargoHash = "sha256-rTDMg9TKHNqLjQztT/AhDYWNZjrRUk+/LM34ofYr/Ws=";

  meta = with lib; {
    description = "Nerdfix helps you to find/fix obsolete nerd font icons in your project";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
