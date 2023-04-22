{ lib
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "5.4";

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    hash = "sha256-+2AfAKyH5apYKoExXtlnaM41EygHKdP1H3kxLiuLlKw=";
  };

  nativeCheckInputs = [ zope_testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    license = licenses.zpl21;
  };
}
