{ lib
, buildPythonPackage
, fetchPypi
, cairosvg
, python
, sphinx
, wavedrom
, xcffib
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-wavedrom";
  version = "2.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0nk36zqq5ipxqx9izz2iazb3iraasanv3nm05bjr21gw42zgkz22";
  };

  propagatedBuildInputs = [
    cairosvg
    sphinx
    wavedrom
    xcffib
  ];

  meta = {
    description = "A sphinx extension that allows generating wavedrom diagrams based on their textual representation";
    homepage = https://github.com/bavovanachte/sphinx-wavedrom;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
