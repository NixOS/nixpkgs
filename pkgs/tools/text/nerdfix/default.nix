{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-cqTaup/MrtLcBIoY+1vQLLlU+Cmu3iODH4jmZImjGrg=";
  };

  cargoHash = "sha256-V/M70ARqOyN0f/uudWPHc4bGc3WXK3PpcM8r2MBEWAs=";

  meta = with lib; {
    description = "Nerdfix helps you to find/fix obsolete nerd font icons in your project";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
