{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docopt,
}:

buildPythonPackage {
  pname = "spoof-mac";
  version = "unstable-2018-01-27";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "feross";
    repo = "SpoofMAC";
    rev = "2cfc796150ef48009e9b765fe733e37d82c901e0";
    sha256 = "sha256-Qiu0URjUyx8QDVQQUFGxPax0J80e2m4+bPJeqFoKxX8=";
  };

  propagatedBuildInputs = [ docopt ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "spoofmac" ];

  meta = with lib; {
    description = "Change your MAC address for debugging purposes";
    homepage = "https://github.com/feross/SpoofMAC";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
