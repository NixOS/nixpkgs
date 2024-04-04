{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-V9f39/9k9kYjngYOSXJYblaKDABPCZbVWxD0p3ZWzlY=";
  };

  cargoHash = "sha256-PkUQZPLzvVJ7s1D9TkMmgIVQiR/E79BRCYmjZVcHIv8=";

  meta = with lib; {
    description = "Nerdfix helps you to find/fix obsolete nerd font icons in your project";
    mainProgram = "nerdfix";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
