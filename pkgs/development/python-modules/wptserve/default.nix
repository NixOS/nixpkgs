{ lib
, buildPythonPackage
, fetchPypi
, six, h2
, isPy3k
}:

buildPythonPackage rec {
  pname = "wptserve";
  version = "3.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11990a92b07e4535c2723c34a88bd905c66acec9cda6efa7a7b61371bfe8d87a";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "h2==" "h2>="
  '';

  propagatedBuildInputs = [ six h2 ];

  meta = {
    description = "A webserver intended for web browser testing";
    homepage =  "https://wptserve.readthedocs.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
