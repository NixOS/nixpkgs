{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  version = "0.2.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-tester";
    tag = version;
    hash = "sha256-PoaY3gPSm+J/C1ad81Dmn7zrbf00pies8CLmLdV+gus=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.9,<0.9.0' 'uv_build'
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
