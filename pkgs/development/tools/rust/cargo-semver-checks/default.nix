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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-upGVWCK3gEPH6BZ7W410AnQPIWOCeD4sawQqPLRowfw=";
  };

  cargoSha256 = "sha256-PYZe7OO/cevictnWGc+NHVpJXctU2XyejF8jPjSNp3M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=dump::tests"
    "--skip=query::tests"
  ];

  meta = with lib; {
    description = "A tool to scan your Rust crate for semver violations";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
