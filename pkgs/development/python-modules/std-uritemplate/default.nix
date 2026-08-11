{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "std-uritemplate";
  version = "2.0.12";
  pyproject = true;

  src = fetchPypi {
    pname = "std_uritemplate";
    inherit (finalAttrs) version;
    hash = "sha256-wkXm2caATkNcRfqU7ko8ilfgiu60WvJhEByw1ROWRTQ=";
  };

  build-system = [ poetry-core ];

  # Module doesn't have unittest, only functional tests
  doCheck = false;

  pythonImportsCheck = [ "stduritemplate" ];

  meta = {
    description = "Std-uritemplate implementation for Python";
    homepage = "https://github.com/std-uritemplate/std-uritemplate";
    changelog = "https://github.com/std-uritemplate/std-uritemplate/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
