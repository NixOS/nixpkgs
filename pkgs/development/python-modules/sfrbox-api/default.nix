{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  click,
  defusedxml,
  fetchFromGitHub,
  mashumaro,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "sfrbox-api";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "sfrbox-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yyfCc36egn5qKZwPpWTndfq0ShacEEEV2PW8FMzjF6k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.21,<0.13" "uv_build"
  '';

  build-system = [ uv-build ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    defusedxml
    mashumaro
  ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    aiointercept
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "sfrbox_api" ];

  meta = {
    description = "Module for the SFR Box API";
    homepage = "https://github.com/hacf-fr/sfrbox-api";
    changelog = "https://github.com/hacf-fr/sfrbox-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sfrbox-api";
  };
})
