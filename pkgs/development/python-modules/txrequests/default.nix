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
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kkxxd17ar5gyjkz9yrrdr15a64qw6ym60ndi0zbwx2s634yfafw";
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
