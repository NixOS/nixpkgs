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
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2t3LWb2oeCYDAePXX1YuIN0o4LLEL58Hxt/1sNeuD3M=";
  };

  cargoSha256 = "sha256-K+eLQ7zGEGkh4vMABWucY/Ho2id/afwl4FSo5+Ca1Ec=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=dump::tests"
    "--skip=query::tests"
    "--skip=verify_binary_contains_lints"
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
