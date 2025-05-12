{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytest-asyncio,
  pytestCheckHook,
  setuptools-scm,
  tornado,
  typeguard,
}:

buildPythonPackage (finalAttrs: {
  pname = "tenacity";
  version = "9.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jd";
    repo = "tenacity";
    tag = finalAttrs.version;
    hash = "sha256-RmoW3gwblwoM4L9QTuc/7gLJJOSxMUYv7FmWxdf/KxE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/jd/tenacity/commit/eed7d785e667df145c0e3eeddff59af64e4e860d.patch";
      includes = [
        "tenacity/__init__.py"
        "tests/test_asyncio.py"
        "tests/test_issue_478.py"
      ];
      hash = "sha256-TMhBjRmG7pBP3iKq83RQzkV9yO2TEcA+3mo9cz6daxs=";
    })
  ];

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
