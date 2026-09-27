{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "socid-extractor";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = "socid-extractor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ct2i4ORFsQqYWvaBjEPlar8DDsGaUssPcI1kOaprq/c=";
  };

  pythonRelaxDeps = [ "beautifulsoup4" ];

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    python-dateutil
    requests
  ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "socid_extractor" ];

  meta = {
    description = "Python module to extract details from personal pages";
    homepage = "https://github.com/soxoj/socid-extractor";
    changelog = "https://github.com/soxoj/socid-extractor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "socid_extractor";
  };
})
