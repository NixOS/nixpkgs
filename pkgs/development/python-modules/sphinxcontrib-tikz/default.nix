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
  version = "0.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c5194055d3219e2ed8d02b52b664d399674154f3db9724ae09e881d091b3d10";
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
