{ lib, buildGoModule, fetchFromGitHub, olm, libsignal-ffi }:

buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "v${version}";
    hash = "sha256-NNylBOtD06hUk8Hf4JojsVS9GHvuqxTKY59m3TgqVsk=";
  };

  buildInputs = [
    olm
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  vendorHash = "sha256-hlr83xuT+9+rj1uJb6iksAjSeVxcHQGm+KUjLbrFZ2Q=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ expipiplus1 niklaskorz ma27 ];
    mainProgram = "mautrix-signal";
  };
}
