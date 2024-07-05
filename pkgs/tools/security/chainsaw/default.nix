{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "chainsaw";
  version = "2.9.1-2";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    rev = "refs/tags/v${version}";
    hash = "sha256-daedJZnWq9UnMDY9P9npngfFbGsv5MSDP4Ep/Pr++ek=";
  };

  cargoHash = "sha256-eSpyh8wnZWU5rY6qhKtxQUFkhkZXzIB2ycPab9LC+OA=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreFoundation ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Rapidly Search and Hunt through Windows Forensic Artefacts";
    homepage = "https://github.com/WithSecureLabs/chainsaw";
    changelog = "https://github.com/WithSecureLabs/chainsaw/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "chainsaw";
  };
}
