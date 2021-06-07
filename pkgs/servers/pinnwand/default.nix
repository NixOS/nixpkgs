{ lib
, python3
, fetchFromGitHub
, fetchpatch
, nixosTests
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "pinnwand";
  version = "1.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    rev = "v${version}";
    sha256 = "046xk2y59wa0pdp7s3hp1gh8sqdw0yl4xab22r2x44iwwcyb0gy5";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    docutils
    pygments
    pygments-better-html
    sqlalchemy
    token-bucket
    toml
    tornado
  ];

  checkInputs = [ pytestCheckHook ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    homepage = "https://supakeen.com/project/pinnwand/";
    license = licenses.mit;
    description = "A Python pastebin that tries to keep it simple";
    maintainers = with maintainers; [ hexa ];
  };
}

