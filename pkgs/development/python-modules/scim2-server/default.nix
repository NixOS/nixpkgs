{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  scim2-filter-parser,
  scim2-models,
  werkzeug,
  pytestCheckHook,
  httpx,
  time-machine,
}:

buildPythonPackage rec {
  pname = "scim2-server";
  version = "0.1.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-server";
    tag = version;
    hash = "sha256-7st/8KI8xWDkeUiID6TUKFdc2U8uFWe+xDUFbe9w22M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.9,<0.9.0' 'uv_build'
  '';

  build-system = [ uv-build ];

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

  meta = {
    description = "Lightweight SCIM2 server prototype";
    homepage = "https://github.com/python-scim/scim2-server";
    changelog = "https://github.com/python-scim/scim2-server/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
