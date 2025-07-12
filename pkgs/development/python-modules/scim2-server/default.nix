{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  scim2-filter-parser,
  scim2-models,
  werkzeug,
  pytestCheckHook,
  httpx,
  time-machine,
}:

buildPythonPackage rec {
  pname = "scim2-server";
  version = "0.1.5";

  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "scim2_server";
    hash = "sha256-VCJVLnYg3+Kz7/DXWnZXkFqXVszsd2hm3cLY22J4NRw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    scim2-filter-parser
    scim2-models
    werkzeug
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpx
    time-machine
  ];

  pythonImportsCheck = [ "scim2_server" ];

  meta = with lib; {
    description = "Lightweight SCIM2 server prototype";
    homepage = "https://github.com/python-scim/scim2-server";
    changelog = "https://github.com/python-scim/scim2-server/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ erictapen ];
  };
}
