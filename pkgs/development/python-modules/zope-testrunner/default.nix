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
  version = "8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.testrunner";
    tag = version;
    hash = "sha256-MqlS/VkLAv9M1WtJ6t2nPMZPH+Cz5wfy2VhtCx/Fwmw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
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
