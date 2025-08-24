{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_dns";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EVBH+l2/cntvKXT/JYqUGeQq4FpDpB4jpLtHUnhlVh0=";
  };

  cargoHash = "sha256-oJqPE/ZJ7WZK1bmx50EnyC32IdvmmpiEH6azA4JqchQ=";

  # tests need filesystem actions that are not possible inside build sandbox
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for dns queries";
    mainProgram = "nu_plugin_dns";
    homepage = "https://github.com/dead10ck/nu_plugin_dns";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux;
  };
})
