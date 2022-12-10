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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "v${version}";
    hash = "sha256-KzbtuDTMXsp9yf3hiiG6VzpUbSEm3bOtujApsG37H14=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    sphinx
  ];

  checkInputs = [
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
