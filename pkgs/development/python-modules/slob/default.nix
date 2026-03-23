{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  pyicu,

  # build-system
  setuptools,

  # tests
  python,
}:

buildPythonPackage {
  pname = "slob";
  version = "0-unstable-2024-04-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "itkach";
    repo = "slob";
    rev = "c21d695707db7d2fe4ec7ec27a018bb7b0fcc209";
    hash = "sha256-dy/EaRLx0LwMklk4h2eL8CsyvWN4swcJNs5cULmh46g=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyicu
  ];

  # The tests are part of the same slob.py file, so unittestCheckHook which
  # runs python -m unittest with the `discover` argument which doesn't discover
  # any tests.
  checkPhase = ''
    ${python.interpreter} -m unittest slob
  '';

  pythonImportsCheck = [ "slob" ];

  meta = {
    homepage = "https://github.com/itkach/slob/";
    description = "Reference implementation of the slob (sorted list of blobs) format";
    mainProgram = "slob";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
