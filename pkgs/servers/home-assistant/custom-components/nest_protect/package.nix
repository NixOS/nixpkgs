{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "iMicknl";
  domain = "nest_protect";
  version = "0.4.4";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-nest-protect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WpQKpYVtmyqLWqhyDsImWvpfWagVWe50zG0RsmeU/8Q=";
  };

  # AttributeError: 'async_generator' object has no attribute 'data'
  doCheck = false;

  meta = {
    changelog = "https://github.com/iMicknl/ha-nest-protect/releases/tag/v${finalAttrs.version}";
    description = "Nest Protect integration for Home Assistant";
    homepage = "https://github.com/iMicknl/ha-nest-protect";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
})
