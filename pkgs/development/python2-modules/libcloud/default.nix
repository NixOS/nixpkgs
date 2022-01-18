{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, pycrypto
, requests
, pytest-runner
, pytest
, requests-mock
, typing
, backports_ssl_match_hostname
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "2.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70096690b24a7832cc5abdfda1954b49fddc1c09a348a1e6caa781ac867ed4c6";
  };

  checkInputs = [ mock pytest pytest-runner requests-mock ];
  propagatedBuildInputs = [ pycrypto requests ]
    ++ lib.optionals isPy27 [ typing backports_ssl_match_hostname ];

  preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

  # requires a certificates file
  doCheck = false;

  meta = with lib; {
    description = "A unified interface to many cloud providers";
    homepage = "https://libcloud.apache.org/";
    license = licenses.asl20;
  };

}
