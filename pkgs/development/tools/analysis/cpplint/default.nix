{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "cpplint";
  version = "1.7-unreleased";
  pyproject = true;

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = "cpplint";
    repo = "cpplint";
    rev = "9be08b54bf2621eb8e52f813f33f5310af4b334e";
    hash = "sha256-OnN0egGviM1zQqwG1KkbO6+QDnGdblyP7KstkUl1xZY=";
  };

  postPatch = ''
    patchShebangs cpplint_unittest.py
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
    parameterized
    wrapPython
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
