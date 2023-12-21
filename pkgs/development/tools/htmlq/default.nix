{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "htmlq";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mgdm";
    repo = "htmlq";
    rev = "v${version}";
    sha256 = "sha256-kZtK2QuefzfxxuE1NjXphR7otr+RYfMif/RSpR6TxY0=";
  };

  cargoSha256 = "sha256-r9EnQQPGpPIcNYb1eqGrMnRdh0snIa5iVsTYTI+YErY=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "Like jq, but for HTML";
    homepage = "https://github.com/mgdm/htmlq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben nerdypepper ];
  };
}
