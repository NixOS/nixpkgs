{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = "cargo-semver-check";
    rev = "v${version}";
    sha256 = "sha256-gB8W/u/Yb/rMMB+654N3Mj4QbTMWGK6cgQKM0lld/10=";
  };

  cargoSha256 = "sha256-ML4cTNtCvaLFkt1QdA34QvAGhrFTO90xw7fsUD2weqQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=adapter::tests"
    "--skip=query::tests"
  ];

  meta = with lib; {
    description = "A tool to scan your Rust crate for semver violations";
    homepage = "https://github.com/obi1kenobi/cargo-semver-check";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
