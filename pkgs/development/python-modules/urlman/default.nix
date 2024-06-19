{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "urlman";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andrewgodwin";
    repo = "urlman";
    rev = version;
    hash = "sha256-p6lRuMHM2xJrlY5LDa0XLCGQPDE39UwCouK6e0U9zJE=";
  };

  pythonImportsCheck = [ "urlman" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Django URL pattern helpers";
    homepage = "https://github.com/andrewgodwin/urlman";
    changelog = "https://github.com/andrewgodwin/urlman/blob/${src.rev}/CHANGELOG";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
