{ lib, buildGoModule, fetchFromGitHub, olm, libsignal-ffi }:

buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "v${version}";
    hash = "sha256-JybQhVej82aWcsGLKS/tCBUuy9rARSe4d+ivYEZ0ve4=";
  };

  buildInputs = [
    olm
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  vendorHash = "sha256-LHq/CH53/Jzh49qXdoqXURqTVbSitczw3yH3KU2BMpc=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ expipiplus1 niklaskorz ma27 ];
    mainProgram = "mautrix-signal";
  };
}
