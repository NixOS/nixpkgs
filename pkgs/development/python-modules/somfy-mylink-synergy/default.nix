{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "somfy-mylink-synergy";
  version = "1.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bendews";
    repo = "somfy-mylink-synergy";
    rev = "v${version}";
    hash = "sha256-+dWHtfDqi48Obknjdu5XbrY0/DRc6vOJcr91WhY6Qak=";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "somfy_mylink_synergy" ];

  meta = {
    description = "Python API to utilise the Somfy Synergy JsonRPC API";
    homepage = "https://github.com/bendews/somfy-mylink-synergy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
