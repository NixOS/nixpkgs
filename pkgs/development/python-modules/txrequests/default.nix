{ stdenv
, buildPythonPackage
, fetchPypi
, twisted
, requests
, cryptography
, python
}:

buildPythonPackage rec {
  pname = "txrequests";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b452a1cafa4d005678f6fa47922a330feb4907d5b4732d1841ca98e89f1362e1";
  };

  propagatedBuildInputs = [ twisted requests cryptography ];

  # Require network access
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    description = "Asynchronous Python HTTP for Humans.";
    homepage    = "https://github.com/tardyp/txrequests";
    license     = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };

}
