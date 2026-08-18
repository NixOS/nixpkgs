{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  packaging,
  pdm-backend,
  httpx,
  flask,
  pytest-httpserver,
  pytest-mock,
  pytestCheckHook,
  requests-wsgi-adapter,
  trustme,
}:

buildPythonPackage rec {
  pname = "unearth";
  version = "0.18.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HlPX9S9G3V+HXnf/HFWxJHfiFaCS5LZsl2SnffSptSA=";
  };

  patches = [
    # https://github.com/frostming/unearth/pull/176
    (fetchpatch {
      name = "fix-packaging-26.0-changes.patch";
      url = "https://github.com/frostming/unearth/commit/69ece0800edeefb1daf035bb0ee348e17a4393fd.patch";
      hash = "sha256-t/Ubv9qC1Fvh4JsnfVgOZO/O7ZpCGHugBUt9qAjnH8c=";
      excludes = [ "pdm.lock" ];
    })
    # Remove when updating to the first release containing this fix.
    (fetchpatch {
      name = "CVE-2026-73030.patch";
      url = "https://github.com/frostming/unearth/commit/6c78164e7bfa28b8b3d6f247b87e560692e3c8ba.patch";
      hash = "sha256-OEf4YnpNhZcIWaFMSXQP0SA7kRV9FqKIpnkLbUrQj+4=";
    })
  ];

  build-system = [ pdm-backend ];

  dependencies = [
    packaging
    httpx
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    flask
    pytest-httpserver
    pytest-mock
    pytestCheckHook
    requests-wsgi-adapter
    trustme
  ];

  pythonImportsCheck = [ "unearth" ];

  meta = {
    description = "Utility to fetch and download Python packages";
    mainProgram = "unearth";
    homepage = "https://github.com/frostming/unearth";
    changelog = "https://github.com/frostming/unearth/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ betaboon ];
  };
}
