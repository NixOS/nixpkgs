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
  version = "0.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "882e3ccfa202559bf77b90c93ee5eb13ec50cdd7714b3673dc6580dea7236740";
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
