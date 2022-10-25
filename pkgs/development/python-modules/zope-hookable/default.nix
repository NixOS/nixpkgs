{ lib
, buildPythonPackage
, fetchPypi
, zope-testing
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "5.2";

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    sha256 = "sha256-TDAYvPKznPXMz0CCb3mbS4wUAFbbeA+WywyjMqJDvSk=";
  };

  checkInputs = [ zope-testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    license = licenses.zpl21;
  };
}
