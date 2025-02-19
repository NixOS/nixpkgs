{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  version = "0.1.13";

  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit version;
    pname = "scim2_tester";
    hash = "sha256-Jpfxyok46fRCW3aAOFb0BTEI++Ou5lob/0RsoXgzkxk=";
  };

  build-system = [ hatchling ];

  dependencies = [ scim2-client ];

  nativeCheckInputs = [
    pytestCheckHook
    werkzeug
    scim2-server
    pytest-httpserver
    cacert
  ] ++ optional-dependencies.httpx;

  pythonImportsCheck = [ "scim2_tester" ];

  optional-dependencies.httpx = scim2-client.optional-dependencies.httpx;

  meta = with lib; {
    description = "SCIM RFCs server compliance checker";
    homepage = "https://scim2-tester.readthedocs.io/";
    changelog = "https://github.com/python-scim/scim2-tester/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ erictapen ];
  };
}
