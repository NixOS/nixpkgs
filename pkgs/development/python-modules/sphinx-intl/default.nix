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
  version = "2.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = version;
    hash = "sha256-4sFKrUSk8DqPbEM+Q3cRijXyxRSIdkIEAI/mAmB0wB0=";
  };

  propagatedBuildInputs = [
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
