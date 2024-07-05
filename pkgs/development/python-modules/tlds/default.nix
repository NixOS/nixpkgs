{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tlds";
  version = "2023110300";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    rev = "refs/tags/${version}";
    hash = "sha256-rmKqY7Z4bBR4r+w4gH04g0Xm9N7QeMVcuFR3pB/pOQY=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "tlds" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatically updated list of valid TLDs taken directly from IANA";
    homepage = "https://github.com/kichik/tlds";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
