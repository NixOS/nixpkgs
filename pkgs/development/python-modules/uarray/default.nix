{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, setuptools
, setuptools-scm
, matchpy
, numpy
, astunparse
, typing-extensions
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "uarray";
  version = "0.8.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = pname;
    rev = version;
    hash = "sha256-wTKqOw64b+/kdZpSYLwCJATOuo807BWCtVHB4pH58fY=";
  };

  nativeBuildInputs = [ setuptools setuptools-scm ];
  nativeCheckInputs = [ pytestCheckHook pytest-cov ];
  propagatedBuildInputs = [ matchpy numpy astunparse typing-extensions ];

  # Tests must be run from outside the source directory
  preCheck = ''
    cd $TMP
  '';
  pytestFlagsArray = ["--pyargs" "uarray" "-W" "ignore::pytest.PytestRemovedIn8Warning" ];
  pythonImportsCheck = [ "uarray" ];

  meta = with lib; {
    description = "Universal array library";
    homepage = "https://github.com/Quansight-Labs/uarray";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
