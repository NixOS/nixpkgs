{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "whoisdomain";
  version = "1.20250220.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mboot-github";
    repo = "WhoisDomain";
    tag = version;
    hash = "sha256-/f5zV0vgjOIIux4e0mXeFSfY8cNpfGkfeCs3djla2zM=";
  };

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "whoisdomain" ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Module to perform whois lookups";
    mainProgram = "whoisdomain";
    homepage = "https://github.com/mboot-github/WhoisDomain";
    changelog = "https://github.com/mboot-github/WhoisDomain/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
