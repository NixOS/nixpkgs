{ lib, buildPythonPackage, fetchPypi, isPy27 }:


buildPythonPackage rec {
  pname = "versioneer";
  version = "0.19";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4fed39bbebcbd2d07f8a86084773f303cb442709491955a0e6754858e47afae";
  };

  # Couldn't get tests to work because, for instance, they used virtualenv and
  # pip.
  doCheck = false;

  meta = with lib; {
    description = "Version-string management for VCS-controlled trees";
    homepage = "https://github.com/warner/python-versioneer";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ jluttine ];
  };

}
