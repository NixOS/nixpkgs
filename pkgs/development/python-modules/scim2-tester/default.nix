{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  scim2-client,
  pytestCheckHook,
  werkzeug,
  scim2-server,
  pytest-httpserver,
  cacert,
}:

buildPythonPackage rec {
  pname = "scim2-tester";
  version = "0.2.4";

  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "scim2_tester";
    hash = "sha256-r67e3AnqhLWVmtOFDj3P2Baa2Ch3TjyHm3Ol8ZwXH/g=";
  };

  build-system = [ hatchling ];

  dependencies = [ scim2-client ];

  nativeCheckInputs = [
    pytestCheckHook
    werkzeug
    scim2-server
    pytest-httpserver
    cacert
  ]
  ++ optional-dependencies.httpx;

  pythonImportsCheck = [ "scim2_tester" ];

  optional-dependencies.httpx = scim2-client.optional-dependencies.httpx;

  meta = {
    description = "SCIM RFCs server compliance checker";
    homepage = "https://scim2-tester.readthedocs.io/";
    changelog = "https://github.com/python-scim/scim2-tester/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
