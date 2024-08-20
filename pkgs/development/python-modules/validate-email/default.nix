{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "validate-email";
  version = "1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "validate_email";
    hash = "sha256-eEcZ3F94C+MZzdGF3IXdk6/r2267lDgRvEx8X5xyrq8=";
  };

  build-system = [ setuptools ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "validate_email" ];

  meta = with lib; {
    description = "Verify if an email address is valid and really exists";
    homepage = "https://github.com/syrusakbary/validate_email";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ mmahut ];
  };
}
