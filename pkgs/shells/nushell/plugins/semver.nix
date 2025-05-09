{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_semver";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "abusch";
    repo = "nu_plugin_semver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VTMaZUYgb7wZqiZmd5IVxQsjbHx3QC75VQQdJqaCvfY=";
  };

  cargoHash = "sha256-oPP4lwXe4jJLfTjUWfaHxQX6CfHbXO5DajyK4r/l6bo=";

  passthru.update-script = nix-update-script { };

  meta = {
    description = "A nushell plugin to work with semver versions";
    homepage = "https://github.com/abusch/nu_plugin_semver";
    changelog = "https://github.com/abusch/nu_plugin_semver/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koffydrop ];
    mainProgram = "nu_plugin_semver";
    platforms = lib.platforms.linux;
  };
})
