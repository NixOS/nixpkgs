{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_semver";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "abusch";
    repo = "nu_plugin_semver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JF+aY7TW0NGo/E1eFVpBZQoxLxuGja8DSoJy4xgi1Lk=";
  };

  cargoHash = "sha256-609w/7vmKcNv1zSfd+k6TTeU2lQuzHX3W5Y8EqKIiAM=";

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
