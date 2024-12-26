{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pythonOlder,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "socid-extractor";
  version = "0.0.27";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = "socid-extractor";
    tag = "v${version}";
    hash = "sha256-oiXIxNvedEk+EufYzxhvRr8m+kuQRs0J62Yel5JLenQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    python-dateutil
    requests
  ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "socid_extractor" ];

  meta = with lib; {
    description = "Python module to extract details from personal pages";
    homepage = "https://github.com/soxoj/socid-extractor";
    changelog = "https://github.com/soxoj/socid-extractor/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "socid_extractor";
  };
}
