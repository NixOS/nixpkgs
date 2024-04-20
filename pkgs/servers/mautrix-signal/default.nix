{ lib, buildGoModule, fetchFromGitHub, olm, libsignal-ffi }:

buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "v${version}";
    hash = "sha256-T5w5k9fuAq5s6Y6pkGoDHSUHCf+kyURBLY0TtzgO85o=";
  };

  buildInputs = [
    olm
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  vendorHash = "sha256-NuPctTEdj2BjCKqmzASYTlip7cimSff0OuhVIxlh1I8=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "A Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ expipiplus1 niklaskorz ma27 ];
    mainProgram = "mautrix-signal";
  };
}
