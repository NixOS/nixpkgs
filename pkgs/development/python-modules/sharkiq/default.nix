{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "sharkiq";
  version = "1.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JeffResc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UG460uEv1U/KTuVEcXMZlVbK/7REFpotkUk4U7z7KpA=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sharkiq" ];

  meta = with lib; {
    description = "Python API for Shark IQ robots";
    homepage = "https://github.com/JeffResc/sharkiq";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
