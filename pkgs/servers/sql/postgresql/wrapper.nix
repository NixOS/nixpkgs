{
  buildEnv,
  callPackage,
  lib,
  makeBinaryWrapper,
  postgresql,
}:
f:
let
  installedExtensions = f postgresql.pkgs;
  recurse = import ./wrapper.nix {
    # explicitly listed in case they were overridden
    inherit
      buildEnv
      callPackage
      lib
      makeBinaryWrapper
      postgresql
      ;
  };
in
buildEnv (finalAttrs: {
  pname = "${postgresql.pname}-and-plugins";
  inherit (postgresql) version;
  paths = installedExtensions ++ [
    # consider keeping in-sync with `postBuild` below
    postgresql
    postgresql.man # in case user installs this into environment
  ];

  pathsToLink = [
    "/"
    "/bin"
    "/share/postgresql/extension"
    # Unbreaks Omnigres' build system
    "/share/postgresql/timezonesets"
    "/share/postgresql/tsearch_data"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild =
    let
      args = lib.concatMap (ext: ext.wrapperArgs or [ ]) installedExtensions;
    in
    ''
      wrapProgram "$out/bin/postgres" ${lib.concatStringsSep " " args}
    '';

  passthru = {
    inherit installedExtensions;
    inherit (postgresql)
      pkgs
      psqlSchema
      ;

    pg_config = postgresql.pg_config.override {
      outputs = {
        out = finalAttrs.finalPackage;
        man = finalAttrs.finalPackage;
      };
    };

    withJIT = recurse (_: installedExtensions ++ [ postgresql.jit ]);
    withoutJIT = recurse (_: lib.remove postgresql.jit installedExtensions);

    withPackages = f': recurse (ps: installedExtensions ++ f' ps);
  };
})
