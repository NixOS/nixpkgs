{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sorl-thumbnail";
  version = "12.8.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7io8nwuInlmRk4PTeB8TF9ycSSf7RLIvsUN/b+cFS5Y=";
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
