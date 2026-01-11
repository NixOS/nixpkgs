{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "tmb";
  version = "0.1.5";
  format = "setuptools";

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

  meta = {
    description = "Python library that interacts with TMB API";
    homepage = "https://github.com/alemuro/tmb";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
