{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "somfy-mylink-synergy";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bendews";
    repo = "somfy-mylink-synergy";
    rev = "v${version}";
    sha256 = "1aa178b5lxdzfa4z7sjw6ky39dkfazp7dqs9dq78z2zay2sqgmgr";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "somfy_mylink_synergy" ];

  meta = with lib; {
    description = "Python API to utilise the Somfy Synergy JsonRPC API";
    homepage = "https://github.com/bendews/somfy-mylink-synergy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
