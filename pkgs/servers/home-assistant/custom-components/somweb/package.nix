{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  somweb,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "taarskog";
  domain = "somweb";
  version = "1.1.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "home-assistant-component-somweb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-anOcpaGeblFVaP2EFVuxx1EuXnNgxy/QoYqvYJMv1Fo=";
  };

  dependencies = [ somweb ];

  meta = {
    changelog = "https://github.com/taarskog/home-assistant-component-somweb/releases/tag/v${finalAttrs.version}";
    description = "Custom component for Home Assistant to manage garage doors and gates by Sommer through SOMweb";
    homepage = "https://github.com/taarskog/home-assistant-component-somweb";
    maintainers = with lib.maintainers; [ uvnikita ];
    license = lib.licenses.mit;
  };
})
