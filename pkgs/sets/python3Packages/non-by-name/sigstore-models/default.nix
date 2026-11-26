{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  typing-extensions,
  uv-build,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sigstore-models";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "sigstore-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3v0dH0cQ4wUAj8saf4JJ9/OBp2imh+ORiMFDlz598W0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
      "uv_build>=0.9.0,<0.10" "uv_build"
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ uv-build ];

  dependencies = [
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigstore_models" ];

  meta = {
    description = "Pydantic-based, protobuf-free data models for Sigstore";
    homepage = "https://github.com/astral-sh/sigstore-models";
    changelog = "https://github.com/astral-sh/sigstore-models/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
