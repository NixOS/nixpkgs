{
  beautifulsoup4,
  buildHomeAssistantComponent,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  gitMinimal,
  hatchling,
  lib,
  pydantic,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-socket,
  pyyaml,
  requests,
}:
let
  version = "3.14.1";
  src = fetchFromGitHub {
    owner = "solentlabs";
    repo = "cable_modem_monitor";
    tag = "v${version}";
    hash = "sha256-ihMFTOsYAUyYusvHFo7SjLEXdOQHK1yVN08doUov3f4=";
    fetchLFS = true;
  };

  core = buildPythonPackage {
    inherit src version;
    pname = "solentlabs-cable-modem-monitor-core";
    pyproject = true;

    sourceRoot = "${src.name}/packages/cable_modem_monitor_core";

    build-system = [ hatchling ];

    dependencies = [
      beautifulsoup4
      defusedxml
      pydantic
      pyyaml
      requests
    ];

    nativeCheckInputs = [
      cryptography
      pytestCheckHook
      pytest-cov-stub
      pytest-socket
    ];
  };

  catalog = buildPythonPackage {
    inherit src version;
    pname = "solentlabs-cable-modem-monitor-catalog";
    pyproject = true;

    sourceRoot = "${src.name}/packages/cable_modem_monitor_catalog";

    build-system = [ hatchling ];

    dependencies = [
      core
    ];

    nativeCheckInputs = [
      cryptography
      pytestCheckHook
      pytest-socket
    ];

    disabledTestPaths = [
      # test requires `har_capture`
      "tests/test_check_fixture_pii_urls.py"
    ];
  };
in
buildHomeAssistantComponent {
  inherit src version;
  owner = "solentlabs";
  domain = "cable_modem_monitor";

  dependencies = [
    catalog
    core
  ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
    pytest-homeassistant-custom-component
  ];

  disabledTestPaths = [
    # test using `git rev-parse` requires .git
    "tests/lib/test_check_markdown_links.py::test_repo_markdown_links_all_resolve"
  ];

  meta = {
    description = "Home Assistant integration for monitoring cable modem signal quality";
    homepage = "https://solentlabs.io/cable-modem-monitor";
    changelog = "https://github.com/solentlabs/cable_modem_monitor/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
  };
}
