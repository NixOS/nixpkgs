{
  lib,
  argcomplete,
  jinja2,
  meraki,
  rich,
  fetchPypi,
  buildPythonApplication,
  pytestCheckHook,
  requests-mock,
  setuptools,
}:

buildPythonApplication rec {
  pname = "meraki-cli";
  version = "1.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "meraki_cli";
    inherit version;
    hash = "sha256-FHcKgppclc0L6yuCkpVYfr+jq8hNkt7Hq/44mpHMR20=";
  };

  disabledTests = [
    # requires files not in PyPI tarball
    "TestDocVersions"
    "TestHelps"
    # requires running "pip install"
    "TestUpgrade"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    argcomplete
    jinja2
    meraki
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "meraki_cli"
  ];

  meta = with lib; {
    homepage = "https://github.com/PackeTsar/meraki-cli";
    description = "Simple CLI tool to automate and control your Cisco Meraki Dashboard";
    license = licenses.mit;
    maintainers = with maintainers; [ dylanmtaylor ];
    platforms = platforms.unix;
    mainProgram = "meraki";
  };
}
