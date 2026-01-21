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

buildPythonPackage rec {
  pname = "sharkiq";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeffResc";
    repo = "sharkiq";
    tag = "v${version}";
    hash = "sha256-8BLPIvx4r5i0q5dPUdwB2KgPfGC6n14RFzWxJXpBD1Y=";
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
    changelog = "https://github.com/JeffResc/sharkiq/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
