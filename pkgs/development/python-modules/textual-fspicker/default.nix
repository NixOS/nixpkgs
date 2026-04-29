{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  textual,
}:

buildPythonPackage (finalAttrs: {
  pname = "textual-fspicker";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "textual_fspicker";
    hash = "sha256-RiYI2+ahTt/2efxhFq3c8oj0p5+OT//SQPnOLKr55lU=";
  };

  build-system = [ uv-build ];

  dependencies = [
    textual
  ];

  pythonImportsCheck = [ "textual_fspicker" ];

  meta = {
    description = "A Textual widget library for picking things in the filesystem";
    homepage = "https://github.com/davep/textual-fspicker";
    changelog = "https://github.com/davep/textual-fspicker/blob/v${finalAttrs.version}/ChangeLog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kybe236 ];
  };
})
