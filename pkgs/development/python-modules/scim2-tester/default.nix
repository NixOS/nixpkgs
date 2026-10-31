{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  scim2-client,
  scim2-models,
  pytestCheckHook,
  pytest-scim2-server,
  pytest-httpserver,
}:

buildPythonPackage rec {
  pname = "scim2-tester";
  version = "0.6.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-tester";
    tag = version;
    hash = "sha256-V57yIi/0SbvRxqtXbZ5TKbNzieVZpIhx3l0Kwm/N7JE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.13,<0.14.0' 'uv_build'
  '';

  build-system = [ uv-build ];

  dependencies = [
    scim2-client
    scim2-models
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-scim2-server
    pytest-httpserver
  ]
  ++ optional-dependencies.httpx2;

  pythonImportsCheck = [ "scim2_tester" ];

  optional-dependencies.httpx2 = scim2-client.optional-dependencies.httpx2;

  meta = {
    description = "SCIM RFCs server compliance checker";
    homepage = "https://scim2-tester.readthedocs.io/";
    changelog = "https://github.com/python-scim/scim2-tester/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
