{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  version = "1.0.1";
  format = "setuptools";
  pname = "vultr";

  src = fetchFromGitHub {
    owner = "spry-group";
    repo = "python-vultr";
    rev = "v${version}";
    sha256 = "00lc5hdhchvm0472p03019bp9541d8y2773xkjy8vblq9qhys8q7";
  };

  propagatedBuildInputs = [ requests ];

  # Tests disabled. They fail because they try to access the network
  doCheck = false;

  pythonImportsCheck = [ "vultr" ];

  meta = with lib; {
    description = "Vultr.com API Client";
    homepage = "https://github.com/spry-group/python-vultr";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
