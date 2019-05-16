{ stdenv
, buildPythonPackage
, fetchPypi
, pep8
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d08fd398f40f8baf87e15eef8355e92fa541bca4eb8465fefab7ee22f92711b9";
  };

  buildInputs = [pep8];

  meta = with stdenv.lib; {
    description = "A generator library for concise, unambiguous and URL-safe UUIDs";
    homepage = https://github.com/stochastic-technologies/shortuuid/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };

}
