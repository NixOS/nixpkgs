{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, django
, pep8
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "1.0.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RZ8S+hrMNP8hOxNxRnwDJRaWRaMe2YniaIcjOa91Y9U=";
  };

  checkInputs = [
    django
    pep8
  ];

  meta = with lib; {
    description = "A generator library for concise, unambiguous and URL-safe UUIDs";
    homepage = "https://github.com/stochastic-technologies/shortuuid/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };

}
