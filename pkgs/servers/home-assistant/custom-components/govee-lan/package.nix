{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchpatch2,
  govee-led-wez,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/wez/govee-lan-hass/commit/b4cecac5ae00d95c49fcfe3bbfc405cbfc5dd84c.patch";
      hash = "sha256-+MPO4kxxE1nZ/+sIY7v8WukHMrVowgMMBVfRDw2uv8o=";
    })
  ];

  dontBuild = true;

  propagatedBuildInputs = [
    govee-led-wez
  ];

  # AttributeError: 'async_generator' object has no attribute 'config'
  doCheck = false;

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Control Govee lights via the LAN API from Home Assistant";
    homepage = "https://github.com/wez/govee-lan-hass";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.mit;
  };
}
