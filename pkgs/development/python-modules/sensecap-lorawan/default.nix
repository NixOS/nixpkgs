{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lorawan-connection,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "sensecap-lorawan";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "balloob";
    repo = "sensecap-lorawan";
    tag = finalAttrs.version;
    hash = "sha256-gx3sVhvW2bGkYNcrRbuPgm3YPzXFCaH5+nkeI98YWb8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.4,<0.9.0" "uv_build>=0.8.4"
  '';

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ uv-build ];

  dependencies = [ lorawan-connection ];

  optional-dependencies = {
    inherit (lorawan-connection.optional-dependencies) chirpstack tts;
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sensecap_lorawan" ];

  meta = {
    description = "SenseCAP LoRaWAN device models and command-line reader";
    homepage = "https://github.com/balloob/sensecap-lorawan";
    changelog = "https://github.com/balloob/sensecap-lorawan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "sensecap-lorawan";
  };
})
