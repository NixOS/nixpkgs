{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "validate-email";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "validate_email";
    sha256 = "1bxffaf5yz2cph8ki55vdvdypbwkvn2xr1firlcy62vqbzf1jivq";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/syrusakbary/validate_email";
    description = "Verify if an email address is valid and really exists";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.mmahut ];
  };
}
