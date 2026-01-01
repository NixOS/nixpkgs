{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  packaging,
  pluggy,
<<<<<<< HEAD
  virtualenv,
=======
  py,
  six,
  virtualenv,
  toml,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tomli,
  filelock,
  hatchling,
  hatch-vcs,
  platformdirs,
  pyproject-api,
  colorama,
  chardet,
  cachetools,
  testers,
  tox,
<<<<<<< HEAD
  typing-extensions,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "tox";
<<<<<<< HEAD
  version = "4.32.0";
  pyproject = true;
=======
  version = "4.28.4";
  format = "pyproject";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "tox";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-n2tKjT0t8bm6iatukKKcGw0PC+5EJrQEABMIAumRaqE=";
  };

  build-system = [
=======
    hash = "sha256-EKJsFf4LvfDi3OL6iNhKEBl5zlpdLET9RkfHEP7E9xU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "packaging>=22" "packaging"
  '';

  nativeBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hatchling
    hatch-vcs
  ];

<<<<<<< HEAD
  dependencies = [
=======
  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cachetools
    chardet
    colorama
    filelock
    packaging
    platformdirs
    pluggy
<<<<<<< HEAD
    pyproject-api
    virtualenv
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
    typing-extensions
  ];
=======
    py
    pyproject-api
    six
    toml
    virtualenv
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = false; # infinite recursion via devpi-client

  passthru.tests = {
    version = testers.testVersion { package = tox; };
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/tox-dev/tox/releases/tag/${src.tag}";
    description = "Generic virtualenv management and test command line tool";
    mainProgram = "tox";
    homepage = "https://github.com/tox-dev/tox";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
