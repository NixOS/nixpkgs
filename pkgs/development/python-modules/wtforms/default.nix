{ stdenv
, buildPythonPackage
, fetchPypi
, Babel
}:

buildPythonPackage rec {
  version = "2.1";
  pname = "wtforms";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0vyl26y9cg409cfyj8rhqxazsdnd0jipgjw06civhrd53yyi1pzz";
  };

  # Django tests are broken "django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet."
  # This is fixed in master I believe but not yet in 2.1;
  doCheck = false;

  propagatedBuildInputs = [ Babel ];

  meta = with stdenv.lib; {
    homepage = https://github.com/wtforms/wtforms;
    description = "A flexible forms validation and rendering library for Python";
    license = licenses.bsd3;
  };

}
