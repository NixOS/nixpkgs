{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  somweb,
}:

buildHomeAssistantComponent rec {
  owner = "taarskog";
  domain = "somweb";
  version = "1.1.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "home-assistant-component-somweb";
    rev = "refs/tags/v${version}";
    hash = "sha256-anOcpaGeblFVaP2EFVuxx1EuXnNgxy/QoYqvYJMv1Fo=";
  };

  dependencies = [ somweb ];

  meta = with lib; {
    changelog = "https://github.com/taarskog/home-assistant-component-somweb/releases/tag/v${version}";
    description = "Custom component for Home Assistant to manage garage doors and gates by Sommer through SOMweb";
    homepage = "https://github.com/taarskog/home-assistant-component-somweb";
    maintainers = with maintainers; [ uvnikita ];
    license = licenses.mit;
  };
}
