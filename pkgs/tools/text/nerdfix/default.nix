{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-cC8BuDTYpXKAtbIylpLQKZG84N/kMp0jirqJanvEvZo=";
  };

  cargoHash = "sha256-K5bZRHce71hFvw7Ipbk4nazg/Wh4I161/MTQmTZakrQ=";

  meta = with lib; {
    description = "Nerdfix helps you to find/fix obsolete nerd font icons in your project";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
