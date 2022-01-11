{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "htmlq";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mgdm";
    repo = "htmlq";
    rev = "v${version}";
    sha256 = "sha256-pTw+dsbbFwrPIxCimMsYfyAF2zVeudebxVtMQV1cJnE=";
  };

  cargoSha256 = "sha256-jeoSA7w2bk0R3L+/FDn/b+ddTCqY8zFr/2GCxI7OCzM=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "Like jq, but for HTML";
    homepage = "https://github.com/mgdm/htmlq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben nerdypepper ];
  };
}
