{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.11";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lgrbqNK6CdrVo2u05CfVev+ZYa1BbhB4QVCGSMxAvO8=";
  };

  cargoHash = "sha256-3tM84DHGEablj7B0SdX9LdjYh1tq5t5ORjkbp/iqUqg=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
