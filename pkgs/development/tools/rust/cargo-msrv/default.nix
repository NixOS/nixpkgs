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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zIUbPmSlobSC3iJ0ddto40Sa/1xzCYG6eaTjMuUnXNU=";
  };

  cargoSha256 = "sha256-GKU0ootG4fXUGErPplERMVjEBop/0+sfQCYpQwPPcXA=";

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
