{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  characteristic,
  six,
  twisted,
}:

buildPythonPackage {
  pname = "tubes";
  version = "0.2.1-unstable-2023-11-06";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "twisted";
    repo = "tubes";
    rev = "b74680b8e7bcfe64362865356bb9461b77bbd5c0";
    hash = "sha256-E8brnt8CtTEEP1KQTsTsgnl54H4zRGp+1IuoI/Qf5NA=";
  };

  propagatedBuildInputs = [
    characteristic
    six
    twisted
  ];

  checkPhase = ''
    ${python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tubes
  '';

  pythonImportsCheck = [ "tubes" ];

  meta = with lib; {
    description = "Data-processing and flow-control engine for event-driven programs";
    homepage = "https://github.com/twisted/tubes";
    license = licenses.mit;
    maintainers = with maintainers; [ exarkun ];
  };
}
