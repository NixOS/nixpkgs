{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "versioneer";
  version = "0.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-versioneer";
    repo = "python-versioneer";
    tag = finalAttrs.version;
    hash = "sha256-3b7Wfhd24Vym5XCeN/M1832Q1VzvlWi3quTRaZrID2s=";
  };

  nativeBuildInputs = [ setuptools ];

  # Couldn't get tests to work because, for instance, they used virtualenv and pip
  doCheck = false;

  pythonImportsCheck = [ "versioneer" ];

  meta = {
    description = "Version-string management for VCS-controlled trees";
    mainProgram = "versioneer";
    homepage = "https://github.com/python-versioneer/python-versioneer";
    changelog = "https://github.com/python-versioneer/python-versioneer/blob/${finalAttrs.version}/NEWS.md";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ jluttine ];
  };
})
