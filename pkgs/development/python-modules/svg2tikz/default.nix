{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytestCheckHook
}:

buildPythonPackage {
  pname = "svg2tikz";
  version = "unstable-2021-01-12";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xyz2tex";
    repo = "svg2tikz";
    rev = "7a9959c295e1ed73e543474c6f3679d04cebc9e9";
    hash = "sha256-OLMFtEEdcY8ARI+hUSOhMwwcrtOAsbKRJRdDJcuaIBg=";
  };

  propagatedBuildInputs = [
    lxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # upstream hasn't updated the tests in a while
  doCheck = false;

  pythonImportsCheck = [ "svg2tikz" ];

  meta = with lib; {
    homepage = "https://github.com/xyz2tex/svg2tikz";
    description = "Set of tools for converting SVG graphics to TikZ/PGF code";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda gal_bolle ];
  };
}
