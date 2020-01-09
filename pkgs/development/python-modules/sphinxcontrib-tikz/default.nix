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
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f362b11e3c2bd17d5f0f07fec03917c16fc5bbcda6fe31ee137c547ed6b03a3";
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
    homepage = https://bitbucket.org/philexander/tikz;
    maintainers = with maintainers; [ costrouc ];
    license = licenses.bsd3;
  };

}
