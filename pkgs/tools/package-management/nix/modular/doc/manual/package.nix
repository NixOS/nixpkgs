{
  lib,
  mkMesonDerivation,

  meson,
  ninja,
  lowdown-unsandboxed,
  mdbook,
  mdbook-linkcheck,
  jq,
  python3,
  rsync,
  json-schema-for-humans,
  nix-cli,

  # Configuration Options

  version,
}:

mkMesonDerivation (finalAttrs: {
  pname = "nix-manual";
  inherit version;

  workDir = ./.;

  # TODO the man pages should probably be separate
  outputs = [
    "out"
    "man"
  ];

  # Hack for sake of the dev shell
  passthru.externalNativeBuildInputs = [
    meson
    ninja
    (lib.getBin lowdown-unsandboxed)
    mdbook
    mdbook-linkcheck
    jq
    python3
    rsync
  ]
  ++ lib.optional (lib.versionAtLeast (lib.versions.majorMinor version) "2.33") [
    json-schema-for-humans
  ];

  nativeBuildInputs = finalAttrs.passthru.externalNativeBuildInputs ++ [
    nix-cli
  ];

  preConfigure = ''
    chmod u+w ./.version
    echo ${finalAttrs.version} > ./.version
  '';

  postInstall = ''
    mkdir -p ''$out/nix-support
    echo "doc manual ''$out/share/doc/nix/manual" >> ''$out/nix-support/hydra-build-products
  '';

  meta = {
    platforms = lib.platforms.all;
  };
})
