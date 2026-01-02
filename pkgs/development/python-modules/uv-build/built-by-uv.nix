{
  buildPythonPackage,
  uv,
  uv-build,
  anyio,
  pytestCheckHook,
}:
buildPythonPackage {
  pname = "built-by-uv";
  version = "0.1.0";
  pyproject = true;

  src = "${uv.src}/scripts/packages/built-by-uv";

  build-system = [ uv-build ];

  dependencies = [ anyio ];

  pythonImportsCheck = [ "built_by_uv" ];

  nativeCheckInputs = [ pytestCheckHook ];
}
