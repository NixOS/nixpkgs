{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U7ykTLEuREe2GTVswcAw3R3h4zbkWxuI2dt/2689xSA=";
  };

  cargoHash = "sha256-NoxYHwY5XpRiqrOjQsaSWQCXFalNAS9SchaKwHbB2uU=";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  checkFlags = [
    # requires internet access
    "--skip=detects_target_dependencies"
  ];

  preCheck = ''
    patchShebangs scripts/regenerate_test_rustdocs.sh
    substituteInPlace scripts/regenerate_test_rustdocs.sh \
      --replace-fail \
        'TOPLEVEL="$(git rev-parse --show-toplevel)"' \
        "TOPLEVEL=$PWD"
    scripts/regenerate_test_rustdocs.sh
  '';

  meta = with lib; {
    description = "Tool to scan your Rust crate for semver violations";
    mainProgram = "cargo-semver-checks";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
