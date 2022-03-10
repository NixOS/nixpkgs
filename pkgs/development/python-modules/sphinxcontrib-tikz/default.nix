{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, pdf2svg
, texLive
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-tikz";
  version = "0.4.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8f9FNx6WMopcqihUzNlQoPBGYoW2YkFi6W1iaFLD4qU=";
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
