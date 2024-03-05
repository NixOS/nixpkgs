{ lib, buildGoModule, fetchFromGitHub, olm, libsignal-ffi }:

buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "v${version}";
    hash = "sha256-qlWp9SnS8dWZNAua9HOyOrQwBXQFaaWB3eP9aCGlDFc=";
  };

  buildInputs = [
    olm
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  vendorHash = "sha256-sa6M9rMrI7fa8T4su3yfJID4AYB6YnlfrVBM6cPQLvY=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "A Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ expipiplus1 niklaskorz ma27 ];
    mainProgram = "mautrix-signal";
  };
}
