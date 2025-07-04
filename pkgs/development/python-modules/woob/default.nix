{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  babel,
  html2text,
  lxml,
  packaging,
  pillow,
  prettytable,
  pycountry,
  pytestCheckHook,
  python-dateutil,
  python-jose,
  pythonOlder,
  pyyaml,
  requests,
  rich,
  setuptools,
  testers,
  unidecode,
  termcolor,
  responses,
  woob,
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.7";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "woob";
    repo = "woob";
    tag = version;
    hash = "sha256-EZHzw+/BIIvmDXG4fF367wsdUTVTHWYb0d0U56ZXwOs=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "packaging"
    "rich"
    "requests"
  ];

  dependencies = [
    babel
    python-dateutil
    python-jose
    html2text
    lxml
    packaging
    pillow
    prettytable
    pycountry
    pyyaml
    requests
    rich
    unidecode
    termcolor
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # require networking
    "test_ciphers"
    "test_verify"
  ];

  pythonImportsCheck = [ "woob" ];

  passthru.tests.version = testers.testVersion {
    package = woob;
    version = "v${version}";
  };

  meta = {
    changelog = "https://gitlab.com/woob/woob/-/blob/${src.rev}/ChangeLog";
    description = "Collection of applications and APIs to interact with websites";
    mainProgram = "woob";
    homepage = "https://woob.tech";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ DamienCassou ];
  };
}
