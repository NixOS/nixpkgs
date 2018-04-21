{ stdenv, buildPythonPackage, fetchPypi }:


buildPythonPackage rec {

  pname = "versioneer";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dgkzg1r7mjg91xp81sv9z4mabyxl39pkd11jlc1200md20zglga";
  };

  # Couldn't get tests to work because, for instance, they used virtualenv and
  # pip.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Version-string management for VCS-controlled trees";
    homepage = https://github.com/warner/python-versioneer;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ jluttine ];
  };

}
