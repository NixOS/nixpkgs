{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_semver";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "abusch";
    repo = "nu_plugin_semver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RrkOVo5MTLtVAp6d+Y1oP3jwImXeofXRdGXRFlwYA9I=";
  };

  cargoHash = "sha256-vKrwoPn8MLjzTrR7p3SH7I2LKKieJCm4tuarp4hktKA=";

  passthru.update-script = nix-update-script { };

  meta = {
    description = "Nushell plugin to work with semver versions";
    homepage = "https://github.com/abusch/nu_plugin_semver";
    changelog = "https://github.com/abusch/nu_plugin_semver/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koffydrop ];
    mainProgram = "nu_plugin_semver";
    platforms = lib.platforms.linux;
  };
})
