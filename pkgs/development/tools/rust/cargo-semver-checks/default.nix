{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nxQ060M5TEUMKtJZ1j3A3v3s1cW1mnHy0/2ZXbxoaMc=";
  };

  cargoSha256 = "sha256-D/rY9d50uKkheEeHe6S04TSdmTyUVgrABIYrFOuZudY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=query::tests"
    "--skip=verify_binary_contains_lints"
    "--skip=rustdoc_cmd::tests"
  ];

  # use system openssl
  OPENSSL_NO_VENDOR = true;

  meta = with lib; {
    description = "A tool to scan your Rust crate for semver violations";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
