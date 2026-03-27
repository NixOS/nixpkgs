{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "whoisdomain";
  version = "1.20260106.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mboot-github";
    repo = "WhoisDomain";
    tag = finalAttrs.version;
    hash = "sha256-OQlOqDmBhqHVFs6U3lC1EryNu4UEi8fzKERkOE3uBaw=";
  };

  build-system = [ hatchling ];

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
