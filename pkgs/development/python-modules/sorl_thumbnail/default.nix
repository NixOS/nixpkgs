{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sorl-thumbnail";
  version = "11.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "050b9kzbx7jvs3qwfxxshhis090hk128maasy8pi5wss6nx5kyw4";
  };

  # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://sorl-thumbnail.readthedocs.org/en/latest/;
    description = "Thumbnails for Django";
    license = licenses.bsd3;
  };

}
