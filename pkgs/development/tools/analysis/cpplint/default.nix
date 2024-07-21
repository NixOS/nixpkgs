{ lib, python3Packages, fetchFromGitHub, fetchpatch }:

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

  patches = [
    # Refactor deprecated unittest aliases
    (fetchpatch {
      url = "https://github.com/cpplint/cpplint/commit/3142f33f17e8aca3dd5c075b3b2106d1f94e3531.patch";
      hash = "sha256-+9J2Z4wQQdt3WX5aoA9pSSdXHLhKMrsiFQO6KRsejjg=";
     })
    # Drop deprecated sre_compile usage
    (fetchpatch {
      url = "https://github.com/cpplint/cpplint/pull/214.patch";
      hash = "sha256-V/lqryzJjFdpuwqVwO2FhsImWrjb7+OrIho/oJFhgOc=";
     })
  ];

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
    pytest_7
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
