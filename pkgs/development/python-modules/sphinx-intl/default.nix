{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  transifex-cli,
  babel,
  click,
  setuptools,
  sphinx,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "sphinx-intl";
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx-intl";
    tag = version;
    hash = "sha256-5Ro+UG9pwwp656fYyCsna6P4s9Gb86Tu3Qm2WUI7tsE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    babel
    click
    setuptools
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    transifex-cli
  ];

  pythonImportsCheck = [ "sphinx_intl" ];

  meta = with lib; {
    description = "Sphinx utility that make it easy to translate and to apply translation";
    homepage = "https://github.com/sphinx-doc/sphinx-intl";
    license = licenses.bsd2;
    maintainers = with maintainers; [ thornycrackers ];
  };
}
