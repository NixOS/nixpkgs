{ lib, rustPlatform, fetchFromGitLab, stdenv, darwin, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "matrix-conduit";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "conduit";
    rev = "v${version}";
    sha256 = "sha256-GSCpmn6XRbmnfH31R9c6QW3/pez9KHPjI99dR+ln0P4=";
  };

  # https://github.com/rust-lang/cargo/issues/11192
  # https://github.com/ruma/ruma/issues/1441
  postPatch = ''
    pushd $cargoDepsCopy
    sed -i ruma*/Cargo.toml \
      -e 's/serde = { workspace = true/serde = { features = [ "derive" ], version = "*"/g' \
      -e 's/tracing = { workspace = true.*/tracing = { version = "*" }/g' \
      -e 's/workspace = true/version = "*"/g'
    for p in ruma*; do echo '{"files":{},"package":null}' > $p/.cargo-checksum.json; done
    popd
  '';

  cargoSha256 = "sha256-WFoupcuaG7f7KYBn/uzbOzlHHLurOyvm5e1lEcinxC8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # tests failed on x86_64-darwin with SIGILL: illegal instruction
  doCheck = !(stdenv.isx86_64 && stdenv.isDarwin);

  passthru.tests = {
    inherit (nixosTests) matrix-conduit;
  };

  meta = with lib; {
    description = "A Matrix homeserver written in Rust";
    homepage = "https://conduit.rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pstn piegames pimeys ];
    mainProgram = "conduit";
  };
}
