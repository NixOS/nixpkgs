{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "validate-email";
  version = "1.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "validate_email";
    hash = "sha256-eEcZ3F94C+MZzdGF3IXdk6/r2267lDgRvEx8X5xyrq8=";
  };

  build-system = [ setuptools ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "validate_email" ];

  meta = {
    description = "Verify if an email address is valid and really exists";
    homepage = "https://github.com/syrusakbary/validate_email";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mmahut ];
  };
}
