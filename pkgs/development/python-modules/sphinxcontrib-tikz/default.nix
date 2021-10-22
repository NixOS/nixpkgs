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
  version = "0.4.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27f9a7a6a64f1bf3ea4dd0e963b7da7c7778948856c8d557a71d64ace086519f";
  };

  postPatch = ''
    substituteInPlace sphinxcontrib/tikz.py \
      --replace "config.latex_engine" "'${texLive}/bin/pdflatex'" \
      --replace "system(['pdf2svg'" "system(['${pdf2svg}/bin/pdf2svg'"
  '';

  propagatedBuildInputs = [ sphinx ];

  # no tests in package
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.tikz" ];

  meta = with lib; {
    description = "TikZ extension for Sphinx";
    homepage = "https://bitbucket.org/philexander/tikz";
    maintainers = with maintainers; [ costrouc ];
    license = licenses.bsd3;
  };

}
