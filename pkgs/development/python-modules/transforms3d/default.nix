{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  numpy,
  scipy,
  sympy,
}:

buildPythonPackage rec {
  pname = "transforms3d";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthew-brett";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-GgnjvwAfyxnDfBGvgMFIPPbR88BWFiNGrScVORygq94=";
  };

  propagatedBuildInputs = [
    numpy
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];
  pythonImportsCheck = [ "transforms3d" ];

  meta = with lib; {
    homepage = "https://matthew-brett.github.io/transforms3d";
    description = "Convert between various geometric transformations";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
