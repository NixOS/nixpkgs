{ lib
, buildPythonPackage
, fetchPypi
, zope-testing
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "5.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    hash = "sha256-+2AfAKyH5apYKoExXtlnaM41EygHKdP1H3kxLiuLlKw=";
  };

  nativeCheckInputs = [ zope-testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    license = licenses.zpl21;
  };
}
