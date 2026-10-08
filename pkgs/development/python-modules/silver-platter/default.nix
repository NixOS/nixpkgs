{
  lib,
  stdenv,
  buildPythonPackage,
  pkgs,
  pkg-config,
  rustPlatform,
  cargo,
  rustc,
  libiconv,
  openssl,

  setuptools,
  setuptools-rust,
  breezy,
  dulwich,
  jinja2,
  pyyaml,
  ruamel-yaml,
}:

let
  inherit (pkgs) silver-platter;
in
buildPythonPackage {
  inherit (silver-platter)
    pname
    version
    src
    cargoDeps
    ;

  pyproject = true;

  dependencies = [
    setuptools
    breezy
    dulwich
    jinja2
    pyyaml
    ruamel-yaml
  ];
  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  pythonImportsCheck = [ "silver_platter" ];

  meta = {
    inherit (silver-platter.meta)
      description
      homepage
      license
      maintainers
      ;
  };
}
