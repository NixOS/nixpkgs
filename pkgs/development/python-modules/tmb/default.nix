{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tmb";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alemuro";
    repo = "tmb";
    rev = version;
    hash = "sha256-XuRhRmeTXAplb14UwISyzaqEIrFeg8/aCdMxUccMUos=";
  };

  VERSION = version;

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "tmb" ];

  # Project has no tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Python library that interacts with TMB API";
    homepage = "https://github.com/alemuro/tmb";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library that interacts with TMB API";
    homepage = "https://github.com/alemuro/tmb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
