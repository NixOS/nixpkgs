{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, pep8
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "1.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c11d2007b915c43bee3e10625f068d8a349e04f0d81f08f5fa08507427ebf1f";
  };

  buildInputs = [pep8];

  meta = with stdenv.lib; {
    description = "A generator library for concise, unambiguous and URL-safe UUIDs";
    homepage = "https://github.com/stochastic-technologies/shortuuid/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };

}
