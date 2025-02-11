{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  sphinx,
  wavedrom,
  xcffib,
  cairosvg,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-wavedrom";
  version = "3.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0zTHVBr9kXwMEo4VRTFsxdX2HI31DxdHfLUHCQmw1Ko=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    sphinx
    wavedrom
    xcffib
    cairosvg
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.wavedrom" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension that allows including wavedrom diagrams by using its text-based representation";
    homepage = "https://github.com/bavovanachte/sphinx-wavedrom";
    license = licenses.mit;
    maintainers = with maintainers; [ fsagbuya ];
  };
}
