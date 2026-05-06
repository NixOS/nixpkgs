{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools-scm,
  tornado,
  typeguard,
}:

buildPythonPackage (finalAttrs: {
  pname = "tenacity";
  version = "9.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jd";
    repo = "tenacity";
    tag = finalAttrs.version;
    hash = "sha256-JiWfIlStps3HZQw4KEohKAUWWZtMAuluXXzvqU+p8V4=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    tornado
    typeguard
  ];

  pythonImportsCheck = [ "tenacity" ];

  meta = {
    homepage = "https://github.com/jd/tenacity";
    changelog = "https://github.com/jd/tenacity/releases/tag/${finalAttrs.src.tag}";
    description = "Retrying library for Python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
})
