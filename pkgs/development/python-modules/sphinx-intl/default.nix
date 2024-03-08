{ lib
, buildPythonPackage
, fetchFromGitHub
, transifex-cli
, babel
, click
, setuptools
, sphinx
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "sphinx-intl";
  version = "2.1.0";
  format = "setuptools";

 src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = version;
    hash = "sha256-U/YCviGrsZNruVzfP0P2dGcB0K0Afh+XUZtp71OeP6c=";
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
