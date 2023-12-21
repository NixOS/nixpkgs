{ lib
, stdenv
, makeWrapper
, matrix-synapse-unwrapped
, extras ? [
    "postgres"
    "url-preview"
    "user-search"
  ] ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform matrix-synapse-unwrapped.python.pkgs.systemd) "systemd"
, plugins ? [ ]
, ...
}:

let
  extraPackages = lib.concatMap (extra: matrix-synapse-unwrapped.optional-dependencies.${extra}) (lib.unique extras);

  pluginsEnv = matrix-synapse-unwrapped.python.buildEnv.override {
    extraLibs = plugins;
  };

  searchPath = lib.makeSearchPathOutput "lib" matrix-synapse-unwrapped.python.sitePackages (extraPackages ++ [ pluginsEnv ]);
in
stdenv.mkDerivation {
  name = (lib.appendToName "wrapped" matrix-synapse-unwrapped).name;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    for bin in ${matrix-synapse-unwrapped}/bin/*; do
      echo $bin
      makeWrapper "$bin" "$out/bin/$(basename $bin)" \
        --set PYTHONPATH ${searchPath}
    done;
  '';

  passthru = {
    unwrapped = matrix-synapse-unwrapped;

    # for backward compatibility
    inherit (matrix-synapse-unwrapped) plugins tools;
  };
}
