{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "1.6.1";
  pyproject = true;

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = "cpplint";
    repo = "cpplint";
    rev = "refs/tags/${version}";
    hash = "sha256-N5YrlhEXQGYxhsJ4M5dGYZUzA81GKRSI83goaqbtCkI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner==5.2"' ""

    patchShebangs cpplint_unittest.py

    substituteInPlace cpplint_unittest.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
    pytest-runner
  ];

  checkPhase = ''
    ./cpplint_unittest.py
  '';

  meta = {
    homepage = "https://github.com/cpplint/cpplint";
    description = "Static code checker for C++";
    mainProgram = "cpplint";
    maintainers = [ lib.maintainers.bhipple ];
    license = [ lib.licenses.bsd3 ];
  };
}
