{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage rec {
  pname = "whoisdomain";
  version = "1.20250929.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mboot-github";
    repo = "WhoisDomain";
    tag = version;
    hash = "sha256-dyppd/6cBIkiiGm4S3khaNZ2DDyRrxWjeMqGYOMZ9YM=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "whoisdomain" ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Module to perform whois lookups";
    homepage = "https://github.com/mboot-github/WhoisDomain";
    changelog = "https://github.com/mboot-github/WhoisDomain/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "whoisdomain";
  };
}
