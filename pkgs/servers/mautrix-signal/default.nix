{ lib, buildGoModule, fetchFromGitHub, olm, libsignal-ffi }:

buildGoModule {
  pname = "mautrix-signal";
  # mautrix-signal's latest released version v0.4.3 still uses the Python codebase
  # which is broken for new devices, see https://github.com/mautrix/signal/issues/388.
  # The new Go version fixes this by using the official libsignal as a library and
  # can be upgraded to directly from the Python version.
  version = "unstable-2024-01-31";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "103666990f30a692c63dd84a499b0dd390cef8a4";
    hash = "sha256-UttLMI+jX5PNG02vs7Dty8pxdko2aM0sVB/90eWwmYw=";
  };

  buildInputs = [
    olm
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  vendorHash = "sha256-LKs/9yCJ7alKQh1VYQsPEg7y+ugZwUnnJh2l4IEjbaQ=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "A Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ expipiplus1 niklaskorz ma27 ];
    mainProgram = "mautrix-signal";
  };
}
