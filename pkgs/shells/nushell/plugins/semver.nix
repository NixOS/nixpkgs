{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_semver";
  version = "0.11.9";

  src = fetchFromGitHub {
    owner = "abusch";
    repo = "nu_plugin_semver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RdVN2KqEf/5Ir8n6+CUXYZMBb2GFenYNKcudq9Abg9g=";
  };

  cargoHash = "sha256-/SB1jCZFM56v0bnxwOqds6N3jGuIpM7RtZaqiSk1xdE=";

  passthru.update-script = nix-update-script { };

  meta = {
    description = "Nushell plugin to work with semver versions";
    homepage = "https://github.com/abusch/nu_plugin_semver";
    changelog = "https://github.com/abusch/nu_plugin_semver/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koffydrop ];
    mainProgram = "nu_plugin_semver";
  };
})
