{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, sphinxHook
, sphinx-rtd-theme
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.15.0";
  outputs = [ "out" "doc" ];
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = pname;
    rev = version;
    hash = "sha256-1hEhVoW3Bp5lD6+8m0Q9OhT8IPnlYWXp+zYDVNm+oao=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  pythonImportsCheck = [
    "wrapt"
  ];

  meta = with lib; {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
