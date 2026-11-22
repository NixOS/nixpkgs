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
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = "socid-extractor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7fNKXEYBkyO42pDH71onqwAp6HvfuVrZlIHwjnJ0uPs=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "socid_extractor";
  };
})
