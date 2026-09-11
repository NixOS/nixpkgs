{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  scim2-models,
  precis-i18n,
  cryptography,
  pytestCheckHook,
  httpx2,
  time-machine,
  aiosqlite,
  scim2-client,
  scim2-tester,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "scim2-server";
  version = "0.8.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-server";
    tag = finalAttrs.version;
    hash = "sha256-ZPhRwCLcpegKI+/wsTML4Xk/PQq/0maip1272FXsr1U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.13,<0.14.0' 'uv_build'
  '';

  build-system = [ uv-build ];

  dependencies = [
    scim2-models
  ];

  optional-dependencies = {
    precis = [ precis-i18n ];
    cursor = [ cryptography ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    httpx2
    time-machine
    aiosqlite
    scim2-client
    (scim2-tester.overridePythonAttrs {
      # Avoid circular dependency
      doCheck = false;
    })
    werkzeug
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "scim2_server" ];

  meta = {
    description = "Lightweight SCIM2 server prototype";
    homepage = "https://github.com/python-scim/scim2-server";
    changelog = "https://github.com/python-scim/scim2-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
