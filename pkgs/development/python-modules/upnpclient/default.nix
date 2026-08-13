{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  python-dateutil,
  lxml,
  ifaddr,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "upnpclient";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flyte";
    repo = "upnpclient";
    tag = finalAttrs.version;
    hash = "sha256-bT7oNCYAKJvhCaSczLWnDAy+ULqhjP+3ZvFnIGAb+Ww=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    python-dateutil
    lxml
    ifaddr
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "upnpclient" ];

  meta = {
    description = "Python 3 library for accessing UPnP devices";
    homepage = "https://github.com/flyte/upnpclient";
    changelog = "https://github.com/flyte/upnpclient/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eana ];
  };
})
