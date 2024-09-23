{ lib, fetchpatch, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "1.7.0";
  pyproject = true;

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = "cpplint";
    repo = "cpplint";
    # Commit where version was bumped to 1.7.0, no tag available
    rev = "8f62396aff6dc850415cbe5ed7edf9dc95f4a731";
    hash = "sha256-EKD7vkxJjoKWfPrXEQRA0X3PyAoYXi9wGgUFT1zC4WM=";
  };

  patches = [
    # Whitespace fixes that make the tests pass
    (fetchpatch {
      url = "https://github.com/cpplint/cpplint/commit/fd257bd78db02888cf6b5985ab8f53d6b765704f.patch";
      hash = "sha256-BNyW8QEY9fUe2zMG4RZzBHASaIsu4d2FJt5rX3VgkrQ=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner==5.2"' ""

    patchShebangs cpplint_unittest.py
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
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
