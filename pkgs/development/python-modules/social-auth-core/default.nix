{ lib
, buildPythonPackage
, fetchPypi
, requests
, oauthlib
, requests_oauthlib
, six
, pyjwt
, defusedxml
, python3-openid
, python3-saml
, cryptography
, pyjwkest
, httpretty
, coverage
, nose
, rednose
, xmlsec
}:

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ygwycji97jw9rhxj8xbdp5y9nawgd7lymb8clbybxkmmda3ffbv";
  };

  patches = [
    /*
      - use native unittest instead of unittest2py3k package
      - unpin httpretty
    */
    ./fix-deps.patch
  ];

  propagatedBuildInputs = [
    requests
    oauthlib
    requests_oauthlib
    six
    pyjwt
    defusedxml
    python3-openid
    python3-saml
    cryptography
    pyjwkest
  ];

  checkInputs = [
    httpretty
    coverage
    nose
    rednose
  ];

  # “import xmlsec” in tests requires libxmlsec1-openssl to be available
  LD_LIBRARY_PATH = lib.makeLibraryPath [ xmlsec ];
  
  # Tests require online access
  doCheck = false;

  meta = with lib; {
    description = "Python social authentication made simple";
    homepage = https://github.com/python-social-auth/social-core;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jtojnar ];
  };
}
