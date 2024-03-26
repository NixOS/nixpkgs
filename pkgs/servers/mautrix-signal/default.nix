{ lib, buildGoModule, fetchFromGitHub, olm, libsignal-ffi }:

buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "v${version}";
    hash = "sha256-juem0enwwY5HOgci9Am2xcAsJK0F48DtpU7J/Osqd9k=";
  };

  buildInputs = [
    olm
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  vendorHash = "sha256-CnuRzDiUVJt4PrU8u7UmT1ejrdpsohmDv8M0qfFb0Ac=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "A Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ expipiplus1 niklaskorz ma27 ];
    mainProgram = "mautrix-signal";
  };
}
