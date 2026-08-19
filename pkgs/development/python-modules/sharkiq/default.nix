{
  lib,
  aiohttp,
  auth0-python,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "sharkiq";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeffResc";
    repo = "sharkiq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-24/cJJ4RaM6twVorJ0pQ/LDHZBTP/rxCiwNozNLS82M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-scm>=9.2.0" "setuptools-scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    auth0-python
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sharkiq" ];

  meta = {
    description = "Python API for Shark IQ robots";
    homepage = "https://github.com/JeffResc/sharkiq";
    changelog = "https://github.com/JeffResc/sharkiq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
