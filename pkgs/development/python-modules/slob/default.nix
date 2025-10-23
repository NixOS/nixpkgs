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
  version = "unstable-2020-06-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "itkach";
    repo = "slob";
    rev = "018588b59999c5c0eb42d6517fdb84036f3880cb";
    hash = "sha256-8JMi4ekSblRUESgHJnUpyRttgMuDBD7924xaCS8sKQQ=";
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
  };
}
