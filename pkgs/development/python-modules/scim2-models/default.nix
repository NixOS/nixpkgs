{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  lark,
  pydantic,
  pytestCheckHook,
  precis-i18n,
}:

buildPythonPackage (finalAttrs: {
  pname = "scim2-models";
  version = "0.12.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-models";
    tag = finalAttrs.version;
    hash = "sha256-W3IdMFoq7jwoD3EAjT8x1MPSgHetgfXtEbjJt2h1dX4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.13,<0.14.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    lark
    pydantic
  ]
  ++ pydantic.optional-dependencies.email;

  nativeCheckInputs = [
    pytestCheckHook
    precis-i18n
  ];

  pythonImportsCheck = [ "scim2_models" ];

  meta = {
    description = "SCIM2 models serialization and validation with pydantic";
    homepage = "https://github.com/python-scim/scim2-models";
    changelog = "https://github.com/python-scim/scim2-models/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
