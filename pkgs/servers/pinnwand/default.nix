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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'click = "^7.0"' 'click = "*"' \
      --replace 'docutils = "^0.16"' 'docutils = "*"' \
      --replace 'sqlalchemy = "^1.3"' 'sqlalchemy = "*"' \
      --replace 'token-bucket = "^0.2.0"' 'token-bucket = "*"'
  '';

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

  disabledTests = [
    # pygments renamed rst to restructuredText, hence a mismatch on this test
    "test_guess_language"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    homepage = "https://supakeen.com/project/pinnwand/";
    license = licenses.mit;
    description = "A Python pastebin that tries to keep it simple";
    maintainers = with maintainers; [ hexa ];
  };
}

