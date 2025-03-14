{
  stdenv,
  runCommand,
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  IOKit,
  CoreFoundation,
  nushell,
  skim,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_skim";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "idanarye";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-TFKybgV2sJqDcTR+F1Kwm03XW0+tt9fLilhSQpX4jSg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5KwosdiWc7K+35d06lvFHaPP52d7ru7tjMG+X9H5oCQ=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    CoreFoundation
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.check =
      let
        nu = lib.getExe nushell;
        plugin = lib.getExe skim;
      in
      runCommand "${pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out skim"
      '';
  };

  meta = with lib; {
    description = "A nushell plugin that adds integrates the skim fuzzy finder";
    mainProgram = "nu_plugin_skim";
    homepage = "https://github.com/idanarye/nu_plugin_skim";
    license = licenses.mit;
    maintainers = with maintainers; [ aftix ];
    platforms = platforms.all;
  };
}
