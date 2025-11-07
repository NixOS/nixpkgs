{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_semver";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "abusch";
    repo = "nu_plugin_semver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ui9zyE5g4LiU2+Csv4p0D61fmPXaDMhnpQ34ggEg3eA=";
  };

  cargoHash = "sha256-5W0GbKz18rQ+3TjNanzV4H4LE/7TLZ+8/FbGHffE2RY=";

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
