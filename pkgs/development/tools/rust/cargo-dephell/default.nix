{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, curl
, openssl
, darwin
, libgit2_1_3_0
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dephell";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mimoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NOjkKttA+mwPCpl4uiRIYD58DlMomVFpwnM9KGfWd+w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    curl
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    darwin.apple_sdk.frameworks.Security
    libgit2_1_3_0
  ];

  # update Cargo.lock to work with openssl 3
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A tool to analyze the third-party dependencies imported by a rust crate or rust workspace";
    homepage = "https://github.com/mimoo/cargo-dephell";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
