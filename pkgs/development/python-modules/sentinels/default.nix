{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sentinels";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PC9k91QYfBngoaApsUi3TPWN0S7Ce04ZwOXW4itamoY=";
  };

  postPatch = ''
    # https://github.com/vmalloc/sentinels/pull/10
    sed -i "/testpaths/d" pyproject.toml
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sentinels" ];

  meta = {
    homepage = "https://github.com/vmalloc/sentinels/";
    description = "Various objects to denote special meanings in python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gador ];
  };
}
