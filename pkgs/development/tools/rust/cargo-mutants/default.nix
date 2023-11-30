{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "23.11.2";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "v${version}";
    hash = "sha256-Rx/3U/wSV4OivUzVyjS+sHiPqCHdaoornngvfn59Bbc=";
  };

  cargoHash = "sha256-8PnxjZIOZ8DPso4Qd29mfiIPpfe3Erjnu5xXHf1eoGk=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # too many tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "A mutation testing tool for Rust";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
