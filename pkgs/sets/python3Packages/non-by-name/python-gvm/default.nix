{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  lxml,
  paramiko,
  pontos,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-gvm";
  version = "27.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "python-gvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c8L7RAX9Zdnze9/vIR4bMPEHeRMPSYXxVUUD+vW4N+g=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = [ hatchling ];

  dependencies = [
    httpx
    lxml
    paramiko
  ]
  ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    pontos
    pytestCheckHook
  ];

  disabledTests = [
    # No running SSH available
    "test_connect_error"
    "test_feed_xml_error"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_feed_xml_error" ];

  pythonImportsCheck = [ "gvm" ];

  meta = {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/python-gvm";
    changelog = "https://github.com/greenbone/python-gvm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
