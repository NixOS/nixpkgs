{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "cpplint";
  version = "2.0-unreleased";
  pyproject = true;

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = "cpplint";
    repo = "cpplint";
    rev = "a3afd5c9a12a0ca46cc9d435b6aafdeb17d48e9a";
    hash = "sha256-Uchx9H7yHLlj71BWcQ0DlT8FOpFQ/9dURVzwuZqyBqw=";
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
