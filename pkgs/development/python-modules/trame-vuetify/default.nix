{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  wheel,
  trame-client,
}:

buildPythonPackage (finalAttrs: {
  name = "trame-vuetify";
  version = "3.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "trame-vuetify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z3E5KTdYmFdfkLHR4FIH3JX2NvQm+9whTRdFsv2gJyk=";
  };

  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
    trame-client
  ];

  pythonImportsCheck = [
    "trame_vuetify.module"
    "trame_vuetify.ui"
    "trame_vuetify.widgets"
  ];

  meta = {
    description = "trame-vuetify brings Vuetify UI Material Components into trame";
    homepage = "https://github.com/kitware/trame-vuetify";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.mit;
  };
})
