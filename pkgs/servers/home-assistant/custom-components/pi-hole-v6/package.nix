{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "bastgau";
  domain = "pi_hole_v6";
  version = "1.22.0b1";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-pi-hole-v6";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vSq4agvFZ5xUVHNdFkzubl0/J/OsYXKMLArnQgYLqlg=";
  };

  # has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/bastgau/ha-pi-hole-v6/releases/tag/${finalAttrs.src.tag}";
    description = "Pi-hole V6 Integration for Home Assistant";
    longDescription = ''
      This custom integration restored compatibility between Home Assistant and Pi-hole, which was no longer supported by the native integration.
      Today, this integration offers additional and complementary features.
    '';
    homepage = "https://github.com/bastgau/ha-pi-hole-v6";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
})
