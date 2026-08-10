{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  tld,
  whodap,
}:

buildPythonPackage (finalAttrs: {
  pname = "whoisdomain";
  version = "2.20260709.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mboot-github";
    repo = "WhoisDomain";
    tag = finalAttrs.version;
    hash = "sha256-9oXKqMdZZFC0orrWMgcpL1mmJil3ENRY5fZjlISupF0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    tld
    whodap
  ];

  pythonImportsCheck = [ "whoisdomain" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Module to perform whois lookups";
    homepage = "https://github.com/mboot-github/WhoisDomain";
    changelog = "https://github.com/mboot-github/WhoisDomain/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "whoisdomain";
  };
})
