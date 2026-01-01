{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
  zope-exceptions,
}:

buildPythonPackage rec {
  pname = "zope-testrunner";
<<<<<<< HEAD
  version = "8.1";
=======
  version = "6.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.testrunner";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-MqlS/VkLAv9M1WtJ6t2nPMZPH+Cz5wfy2VhtCx/Fwmw=";
=======
    hash = "sha256-cvZXQzbIUBq99P0FYSydG1tLNBMFTTvuMvqWGaNFhJc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
=======
      --replace-fail "setuptools<74" "setuptools"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-exceptions
  ];

  pythonImportsCheck = [ "zope.testrunner" ];

  doCheck = false; # custom test modifies sys.path

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Flexible test runner with layer support";
    mainProgram = "zope-testrunner";
    homepage = "https://github.com/zopefoundation/zope.testrunner";
    changelog = "https://github.com/zopefoundation/zope.testrunner/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
