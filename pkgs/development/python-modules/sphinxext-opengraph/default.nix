{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, pytestCheckHook
, beautifulsoup4
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "refs/tags/v${version}";
    hash = "sha256-fNtXj7iYX7rSaGO6JcxC+PvR8WzTFl8gYwHyRExYdfI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
  ];

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = with lib; {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
