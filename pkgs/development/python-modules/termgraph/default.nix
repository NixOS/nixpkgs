{
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "termgraph";
  version = "0.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkaz";
    repo = "termgraph";
    tag = "v${version}";
    hash = "sha256-0J9mEpDIdNEYwO+A+HBOaSw+Ct+HsbSPwGQYuYH6NN8=";
  };

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "termgraph" ];

  meta = with lib; {
    description = "Python command-line tool which draws basic graphs in the terminal";
    mainProgram = "termgraph";
    homepage = "https://github.com/mkaz/termgraph";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
