{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, matplotlib
, pytestCheckHook
, pythonOlder
, beautifulsoup4
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZLIxbFgayG+WVvSXu74eZJ/PbSHg6dzkkIr1OBry4DE=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    sphinx
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
  ];

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = with lib; {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    changelog = "https://github.com/wpilibsuite/sphinxext-opengraph/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
