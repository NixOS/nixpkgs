{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  construct,
  python-miio,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "syssi";
  domain = "xiaomi_miio_fan";
  version = "2026.8.0.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "xiaomi_fan";
    tag = finalAttrs.version;
    hash = "sha256-ad70/bcLis+ZEGqAyQY0P7YX09A/pyQ/nlRdBGt2IOQ=";
  };

  dependencies = [
    construct
    python-miio
  ];

  ignoreVersionRequirement = [ "construct" ];

  meta = {
    description = "Home Assistant integration for Xiaomi Mi Smart Fans";
    homepage = "https://github.com/syssi/xiaomi_fan";
    changelog = "https://github.com/syssi/xiaomi_fan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
