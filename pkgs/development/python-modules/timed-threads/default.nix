{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "timed-threads";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mathics3";
    repo = "python-timed-threads";
    tag = finalAttrs.version;
    hash = "sha256-1xWGN0p3g1ozWktSo995x7lcKHYIh4PWiXeE1wCtVBg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "timed_threads" ];

  meta = {
    description = "Timeout control for Python threads and code blocks";
    homepage = "https://github.com/Mathics3/python-timed-threads";
    changelog = "https://github.com/Mathics3/python-timed-threads/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
