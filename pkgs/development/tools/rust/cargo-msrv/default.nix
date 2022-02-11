{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, pkg-config
, rustup
, openssl
, stdenv
, libiconv
, Security
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rKkU49sqVArp/iCfcG78ieoEbyZoqB1owTwLfl09DSM=";
  };

  cargoSha256 = "sha256-aA4l7kyVnu416LcHddJqrEpi8WS0AImbROZG+kBy5tk=";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  # Integration tests fail
  doCheck = false;

  buildInputs = if stdenv.isDarwin
    then [ libiconv Security ]
    else [ openssl ];

  nativeBuildInputs = [ pkg-config makeWrapper ];

  # Depends at run-time on having rustup in PATH
  postInstall = ''
    wrapProgram $out/bin/cargo-msrv --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
