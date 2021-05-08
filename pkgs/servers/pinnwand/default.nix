{ lib
, python3
, fetchFromGitHub
, fetchpatch
, nixosTests
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "pinnwand";
  version = "1.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p6agvp136q6km7gjfv8dpjn6x4ap770lqa40ifblyhw13bsrqlh";
  };

  patches = [
    (fetchpatch {
      # https://github.com/supakeen/pinnwand/issues/110
      url = "https://github.com/supakeen/pinnwand/commit/b9e72abb7f25104f5e57248294ed9ae1dbc87240.patch";
      sha256 = "098acif9ck165398bp7vwfr9g7sj9q3pcdc42z5y63m1nbf8naan";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    docutils
    pygments
    pygments-better-html
    sqlalchemy
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

