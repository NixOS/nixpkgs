{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  libsignal-ffi,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "v${version}";
    hash = "sha256-OjWRdYAxjYMGZswwKqGKUwCIc5qHkNBTQgIcbiRquH0=";
  };

  buildInputs = (lib.optional (!withGoolm) olm) ++ [
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-oV8ILDEyMpOZy5m2mnPAZj5XAhleO8yNz49wxvZboVs=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      expipiplus1
      niklaskorz
      ma27
    ];
    mainProgram = "mautrix-signal";
  };
}
