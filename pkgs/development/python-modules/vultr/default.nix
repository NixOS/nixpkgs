{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vultr";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spry-group";
    repo = "python-vultr";
    tag = "v${version}";
    hash = "sha256-ByPtIU6Yro28nH2cIzxqgZR0VwpggCsOAXVDBhssjAI=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests disabled. They fail because they try to access the network
  doCheck = false;

  pythonImportsCheck = [ "vultr" ];

  meta = with lib; {
    description = "Vultr.com API Client";
    homepage = "https://github.com/spry-group/python-vultr";
    changelog = "https://github.com/spry-group/python-vultr/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
