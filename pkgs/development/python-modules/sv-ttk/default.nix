{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  tkinter,
}:

buildPythonPackage (finalAttrs: {
  pname = "sv-ttk";
  version = "2.6.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "sv_ttk";
    hash = "sha256-R1idXiA5jPQE6DYvJPPtSPODDNCs4FbYM1T6Jdjk/kg=";
  };

  build-system = [ setuptools ];

  # No tests available
  doCheck = false;

  dependencies = [ tkinter ];

  pythonImportsCheck = [ "sv_ttk" ];

  meta = {
    description = "Gorgeous theme for Tkinter/ttk, based on the Sun Valley visual style";
    homepage = "https://github.com/rdbende/Sun-Valley-ttk-theme";
    changelog = "https://github.com/rdbende/Sun-Valley-ttk-theme/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AngryAnt ];
  };
})
