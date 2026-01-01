{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD

  # dependencies
  pyicu,

  # build-system
  setuptools,

  # tests
=======
  isPy3k,
  pyicu,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  python,
}:

buildPythonPackage {
  pname = "slob";
<<<<<<< HEAD
  version = "0-unstable-2024-04-19";
  pyproject = true;
=======
  version = "unstable-2020-06-26";
  format = "setuptools";
  disabled = !isPy3k;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "itkach";
    repo = "slob";
<<<<<<< HEAD
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
=======
    rev = "018588b59999c5c0eb42d6517fdb84036f3880cb";
    sha256 = "01195hphjnlcvgykw143rf06s6y955sjc1r825a58vhjx7hj54zh";
  };

  propagatedBuildInputs = [ pyicu ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  checkPhase = ''
    ${python.interpreter} -m unittest slob
  '';

  pythonImportsCheck = [ "slob" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/itkach/slob/";
    description = "Reference implementation of the slob (sorted list of blobs) format";
    mainProgram = "slob";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
=======
  meta = with lib; {
    homepage = "https://github.com/itkach/slob/";
    description = "Reference implementation of the slob (sorted list of blobs) format";
    mainProgram = "slob";
    license = licenses.gpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
