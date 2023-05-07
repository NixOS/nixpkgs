{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "whatthepatch";
  version = "1.0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cscorley";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1+OIs77Vyx56pgf7VSmi4UsPgkv8qZXFm8L2jK2CTMk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "whatthepatch" ];

  meta = with lib; {
    description = "Python library for both parsing and applying patch files";
    homepage = "https://github.com/cscorley/whatthepatch";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
