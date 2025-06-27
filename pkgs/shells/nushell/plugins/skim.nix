{
  stdenv,
  runCommand,
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  nushell,
  skim,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_skim";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "idanarye";
    repo = "nu_plugin_skim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8gO6pT40zBlFxPRapIO9qpMI9whutttqYgOPr91B9Ec=";
  };

  cargoHash = "sha256-2poE7Nnwe5rRoU8WknEgzX68z+y9ZplX53v8FURzxmE=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests.check =
      let
        nu = lib.getExe nushell;
        plugin = lib.getExe skim;
      in
      runCommand "${finalAttrs.pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out skim"
      '';
  };

  meta = {
    description = "A nushell plugin that adds integrates the skim fuzzy finder";
    mainProgram = "nu_plugin_skim";
    homepage = "https://github.com/idanarye/nu_plugin_skim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aftix ];
  };
})
