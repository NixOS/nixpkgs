{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bundle-licenses";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "cargo-bundle-licenses";
    rev = "v${version}";
    hash = "sha256-tjxdZ28frY/GRFvhg28DkVajqFC+02962Sgai8NhxK0=";
  };

  cargoHash = "sha256-uVLoRLGnTe/8ipehGbc5mfWuMsFt3KP9KatXEJFUUEI=";

  meta = with lib; {
    description = "Generate a THIRDPARTY file with all licenses in a cargo project";
    homepage = "https://github.com/sstadick/cargo-bundle-licenses";
    changelog = "https://github.com/sstadick/cargo-bundle-licenses/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
