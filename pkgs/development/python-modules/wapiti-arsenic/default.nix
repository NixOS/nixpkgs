{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  attrs,
  packaging,
  structlog,
}:

buildPythonPackage rec {
  pname = "wapiti-arsenic";
  version = "28.2";
  pyproject = true;

  # Latest tag is not on GitHub
  src = fetchPypi {
    pname = "wapiti_arsenic";
    inherit version;
    hash = "sha256-QxjM0BsiHm/LPUuGLLPG6OUcr4YXBEpfJGTwKp1zTWQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=0.12" "poetry-core" \
      --replace-fail "poetry.masonry" "poetry.core.masonry"
  '';

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "structlog"
  ];

  dependencies = [
    aiohttp
    attrs
    packaging
    structlog
  ];

  pythonImportsCheck = [ "wapiti_arsenic" ];

  # No tests in the pypi archive
  doCheck = false;

  meta = {
    description = "Asynchronous WebDriver client";
    homepage = "https://github.com/wapiti-scanner/arsenic";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
