{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, govee-led-wez
}:

buildHomeAssistantComponent {
  owner = "wez";
  domain = "govee_lan";
  version = "unstable-2023-06-10";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "govee-lan-hass";
    rev = "18d8455510d158496f7e5d4f0286f58bd61042bb";
    hash = "sha256-ZhrxEPBEi+Z+2ZOAQ1amhO0tqvhM6tyFQgoRIVNDtXY=";
  };

  dontBuild = true;

  propagatedBuildInputs = [
    govee-led-wez
  ];

  # enable when pytest-homeassistant-custom-component is packaged
  doCheck = false;

  # nativeCheckInputs = [
  #   pytest-homeassistant-custom-component
  #   pytestCheckHook
  # ];

  meta = with lib; {
    description = "Control Govee lights via the LAN API from Home Assistant";
    homepage = "https://github.com/wez/govee-lan-hass";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.mit;
  };
}
