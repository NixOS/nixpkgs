{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  nix-update-script,
  pydantic,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "toon-format";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "toon-format";
    repo = "toon-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HLLTAk+zVyFi48+8TKFeznAwdFJ6ys1BQKj6gtg0fQw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.20,<0.13" "uv_build"
  '';

  build-system = [ uv-build ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "toon_format" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Community-driven Python implementation of TOON";
    homepage = "https://github.com/toon-format/toon-python";
    changelog = "https://github.com/toon-format/toon-python/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
