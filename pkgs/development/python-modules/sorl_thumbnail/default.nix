{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sorl-thumbnail";
  version = "12.7.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbe6dfd66a1aceb7e0203895ff5622775e50266f8d8cfd841fe1500bd3e19018";
  };

  nativeBuildInputs = [ setuptools-scm ];
  # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
  doCheck = false;

  meta = with lib; {
    homepage = "https://sorl-thumbnail.readthedocs.org/en/latest/";
    description = "Thumbnails for Django";
    license = licenses.bsd3;
  };

}
