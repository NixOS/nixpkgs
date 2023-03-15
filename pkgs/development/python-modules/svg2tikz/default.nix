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
  version = "1.2.0";

  disabled = pythonOlder "3.10";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xyz2tex";
    repo = "svg2tikz";
    rev = "refs/tags/v${version}";
    hash = "sha256-oFcKRcXef1Uz0qFi6Gga/D4u8zW0RjXAnHDlhRr33Ts=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "+dairiki.1" ""
  '';

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
    changelog = "https://github.com/xyz2tex/svg2tikz/blob/${src.rev}/README.md#changes-bug-fixes-and-known-problems-from-the-original";
    homepage = "https://github.com/xyz2tex/svg2tikz";
    description = "Set of tools for converting SVG graphics to TikZ/PGF code";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda gal_bolle ];
  };
}
