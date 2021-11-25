{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, pep8
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "1.0.8";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9435e87e5a64f3b92f7110c81f989a3b7bdb9358e22d2359829167da476cfc23";
  };

  buildInputs = [pep8];

  meta = with lib; {
    description = "A generator library for concise, unambiguous and URL-safe UUIDs";
    homepage = "https://github.com/stochastic-technologies/shortuuid/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };

}
