{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  httpx2,
  nix-update-script,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "workos";
  version = "10.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "workos";
    repo = "workos-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NF7D93EhquwdnPd2mQpgRhXnaT5lLoTJx+CGMMKAkXc=";
  };

  build-system = [ uv-build ];

  dependencies = [
    cryptography
    httpx2
    pyjwt
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "workos" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python SDK for interacting with the WorkOS API";
    homepage = "https://github.com/workos/workos-python";
    changelog = "https://github.com/workos/workos-python/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
