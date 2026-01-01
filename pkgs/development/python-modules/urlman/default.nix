{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "urlman";
<<<<<<< HEAD
  version = "2.0.3";
=======
  version = "2.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andrewgodwin";
    repo = "urlman";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-uhIFH8/zRTIGV4ABO+0frp0z8voWl5Ji6rSVRzcx4Og=";
=======
    hash = "sha256-p6lRuMHM2xJrlY5LDa0XLCGQPDE39UwCouK6e0U9zJE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonImportsCheck = [ "urlman" ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Django URL pattern helpers";
    homepage = "https://github.com/andrewgodwin/urlman";
    changelog = "https://github.com/andrewgodwin/urlman/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Django URL pattern helpers";
    homepage = "https://github.com/andrewgodwin/urlman";
    changelog = "https://github.com/andrewgodwin/urlman/blob/${src.rev}/CHANGELOG";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
