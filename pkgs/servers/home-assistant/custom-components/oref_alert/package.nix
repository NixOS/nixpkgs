{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiofiles,
  shapely,
  paho-mqtt,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-freezer,
  pythonOlder,
}:

buildHomeAssistantComponent rec {
  owner = "amitfin";
  domain = "oref_alert";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "amitfin";
    repo = "oref_alert";
    tag = "v${version}";
    hash = "sha256-Az2pZriKPXgLK1QarwycWUEn5VBufUQdYomYlpStOrY=";
  };

  # This package uses the `if TYPE_CHECKING:` pattern in the test code to avoid
  # expensive imports (see https://docs.python.org/3/library/typing.html#typing.TYPE_CHECKING for more info on this pattern).
  # In Python 3.13, this makes tests fail with errors like "NameError: name 'AiohttpClientMocker' is not defined" error.
  # However, Python 3.14 introduces lazy annotations (see https://peps.python.org/pep-0563/), which should fix this problem.
  postPatch = lib.optionalString (pythonOlder "3.14") ''
    find tests -name '*.py' -exec sh -c 'for f; do if ! grep -q "^from __future__ import annotations" "$f"; then sed -i "1i from __future__ import annotations" "$f"; fi; done' sh {} +
  '';

  dependencies = [
    aiofiles
    shapely
    paho-mqtt
  ];

  ignoreVersionRequirement = [ "shapely" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytest-freezer
  ];

  meta = {
    changelog = "https://github.com/amitfin/oref_alert/releases/tag/v${version}";
    description = "Israeli Oref Alerts";
    homepage = "https://github.com/amitfin/oref_alert";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
