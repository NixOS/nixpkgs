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
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ugcmsm1j2a1wOnUe9u70yoRXALCmtXSnb80N4B4IUWE=";
  };

  cargoSha256 = "sha256-PxnPCevjVvmFMlmYv6qwIBZk2MThz65hgUyVhm2tzlc=";

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
