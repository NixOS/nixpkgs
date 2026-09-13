{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  uv-build,

  # dependencies
  textual,

  # tests
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "textual-drivers";
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "NSPC911";
    repo = "textual-drivers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zEsjBVa+G9Qq+Hfcuq7nFcji+3tD+rmFlzHAmamRZC8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.11.16,<0.12.0' 'uv_build>=0.11.16'
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    textual
  ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [ "textual_drivers" ];

  meta = {
    changelog = "https://github.com/NSPC911/textual-drivers/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/NSPC911/textual-drivers";
    description = "Additional terminal drivers for Textual applications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kangazero ];
  };
})
