{ lib, buildGoModule, fetchFromGitHub, olm, libsignal-ffi }:

buildGoModule {
  pname = "mautrix-signal";
  # mautrix-signal's latest released version v0.4.3 still uses the Python codebase
  # which is broken for new devices, see https://github.com/mautrix/signal/issues/388.
  # The new Go version fixes this by using the official libsignal as a library and
  # can be upgraded to directly from the Python version.
  version = "unstable-2023-12-30";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "6abe80e6c79b31b5dc37a484b65d346a1ffd4f05";
    hash = "sha256-EDSP+kU0EmIaYbAB/hxAUTEay+H5aqn9ovBQFZg6wJk=";
  };

  buildInputs = [
    olm
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  vendorHash = "sha256-f3sWX+mBouuxVKu+fZIYTWLXT64fllUWpcUYAxjzQpI=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "A Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ expipiplus1 niklaskorz ma27 ];
    mainProgram = "mautrix-signal";
  };
}
