{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-v1EaC4VBOvZFL2GoKlTDBMjSe8+4bxaLFvy2V7e7RW4=";
  };

  cargoHash = "sha256-k17x7BEaBWo4Ka2HIjHd4DrO/tolKR/+s7Mm5ZzJk/Y=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.DisplayServices
  ];

  postInstall = ''
    installManPage doc/macchina.{1,7}
  '';

  meta = with lib; {
    description = "Fast, minimal and customizable system information fetcher";
    homepage = "https://github.com/Macchina-CLI/macchina";
    changelog = "https://github.com/Macchina-CLI/macchina/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _414owen figsoda ];
    mainProgram = "macchina";
  };
}
