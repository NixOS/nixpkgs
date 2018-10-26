{ stdenv
, buildPythonPackage
, fetchPypi
, pep8
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4606dbb19124d98109c00e2cafae2df8117aec02115623e18fb2abe3f766d293";
  };

  buildInputs = [pep8];

  meta = with stdenv.lib; {
    description = "A generator library for concise, unambiguous and URL-safe UUIDs";
    homepage = https://github.com/stochastic-technologies/shortuuid/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };

}
