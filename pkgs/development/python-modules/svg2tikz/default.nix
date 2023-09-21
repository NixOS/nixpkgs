{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, inkex
, lxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "svg2tikz";
  version = "2.1.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xyz2tex";
    repo = "svg2tikz";
    rev = "refs/tags/v${version}";
    hash = "sha256-v8+0h90uJlkI5eJcwCG55nxPz8n2aJXwP8Ocp48cl9M=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    inkex
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "svg2tikz" ];

  meta = with lib; {
    changelog = "https://github.com/xyz2tex/svg2tikz/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/xyz2tex/svg2tikz";
    description = "Set of tools for converting SVG graphics to TikZ/PGF code";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda gal_bolle ];
  };
}
