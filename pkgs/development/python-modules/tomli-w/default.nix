{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  tomli,
}:

buildPythonPackage (finalAttrs: {
  pname = "tomli-w";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "tomli-w";
    tag = finalAttrs.version;
    hash = "sha256-Du37ySvAL9iwGec5wbWxwLTYm+kcDSOs5OJ5Sw7R87g=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    tomli
  ];

  pythonImportsCheck = [ "tomli_w" ];

  __structuredAttrs = true;

  meta = {
    description = "Write-only counterpart to Tomli, which is a read-only TOML parser";
    homepage = "https://github.com/hukkin/tomli-w";
    changelog = "https://github.com/hukkin/tomli-w/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
})
