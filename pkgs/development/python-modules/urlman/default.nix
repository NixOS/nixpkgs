{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "urlman";
  version = "2.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andrewgodwin";
    repo = "urlman";
    rev = version;
    hash = "sha256-uhIFH8/zRTIGV4ABO+0frp0z8voWl5Ji6rSVRzcx4Og=";
  };

  pythonImportsCheck = [ "urlman" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Django URL pattern helpers";
    homepage = "https://github.com/andrewgodwin/urlman";
    changelog = "https://github.com/andrewgodwin/urlman/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
