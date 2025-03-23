{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
  pdf2svg,
  texliveSmall,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-tikz";
  version = "0.4.20";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LuO9H5yi80nAgjpPNQfZHEEOf5a+IPBR/vevFmXzQco=";
  };

  postPatch = ''
    substituteInPlace sphinxcontrib/tikz.py \
      --replace "config.latex_engine" "'${
        texliveSmall.withPackages (
          ps: with ps; [
            standalone
            pgfplots
          ]
        )
      }/bin/pdflatex'" \
      --replace "system(['pdf2svg'" "system(['${pdf2svg}/bin/pdf2svg'"
  '';

  propagatedBuildInputs = [ sphinx ];

  # no tests in package
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.tikz" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "TikZ extension for Sphinx";
    homepage = "https://bitbucket.org/philexander/tikz";
    maintainers = [ ];
    license = licenses.bsd3;
  };
}
