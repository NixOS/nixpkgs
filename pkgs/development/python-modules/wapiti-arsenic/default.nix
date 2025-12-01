{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  httpx,
  packaging,
}:

buildPythonPackage rec {
  pname = "wapiti-arsenic";
  version = "28.5";
  pyproject = true;

  src = fetchPypi {
    pname = "wapiti_arsenic";
    inherit version;
    hash = "sha256-snIKEdrBOIfPeHkVLv0X5lsBzDbOtDrbOj4m8UNCj60=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=2.1.3" "poetry-core" \
      --replace-fail "poetry.masonry" "poetry.core.masonry"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    packaging
  ];

  pythonImportsCheck = [ "wapiti_arsenic" ];

  # No tests in the pypi archive
  doCheck = false;

  meta = {
    description = "Asynchronous WebDriver client";
    homepage = "https://github.com/wapiti-scanner/arsenic";
    changelog = "https://github.com/wapiti-scanner/arsenic/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
