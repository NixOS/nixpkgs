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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = "cargo-semver-check";
    rev = "v${version}";
    sha256 = "0w5qmbjkbd7ss2a3xhx186bykb3ghk6z0dmbz5i06k3acdv52gi7";
  };

  cargoSha256 = "sha256-RDFKI++5274bquh4bao10PQbdTOoCWcmueajIm8SvTw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=adapter::tests"
  ];

  meta = with lib; {
    description = "A tool to scan your Rust crate for semver violations";
    homepage = "https://github.com/obi1kenobi/cargo-semver-check";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
