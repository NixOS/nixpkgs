{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "bastgau";
  domain = "pi_hole_v6";
  version = "1.22.0b1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-pi-hole-v6";
    tag = "v${version}";
    hash = "sha256-vSq4agvFZ5xUVHNdFkzubl0/J/OsYXKMLArnQgYLqlg=";
  };

  # has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  meta = {
    changelog = "https://github.com/bastgau/ha-pi-hole-v6/releases/tag/${src.tag}";
    description = "Pi-hole V6 Integration for Home Assistant";
    longDescription = ''
      This custom integration restored compatibility between Home Assistant and Pi-hole, which was no longer supported by the native integration.
      Today, this integration offers additional and complementary features.
    '';
    homepage = "https://github.com/bastgau/ha-pi-hole-v6";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
