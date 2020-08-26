{ lib
, substituteAll
, buildPythonPackage
, fetchPypi
, sphinx
, pdf2svg
, texLive
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-tikz";
  version = "0.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "054429a04ed253256a676ecc29f0bae2c644d5bd1150cd95d658990a07ebc8fe";
  };

  patches = [
    (substituteAll {
      src = ./binary-paths.patch;
      inherit texLive pdf2svg;
    })
  ];

  propagatedBuildInputs = [ sphinx ];

  # no tests in package
  doCheck = false;

  meta = with lib; {
    description = "TikZ extension for Sphinx";
    homepage = "https://bitbucket.org/philexander/tikz";
    maintainers = with maintainers; [ costrouc ];
    license = licenses.bsd3;
  };

}
