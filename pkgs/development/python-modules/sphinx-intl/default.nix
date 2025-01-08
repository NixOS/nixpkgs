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
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx-intl";
    tag = version;
    hash = "sha256-VrWtRdI9j/y2m7kN7/m/5cdxpI0dAaiprdXKt8m6MPc=";
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
