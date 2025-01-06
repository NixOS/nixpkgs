{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  ordered-set,
  pillow,
  pythonOlder,
  setuptools,
  setuptools-dso,
  sortedcollections,
}:

buildPythonPackage rec {
  pname = "tilequant";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uW1g3nlT6Y+1beifo/MOlGxsGL7on/jcAROxSddySHk=";
  };

  pythonRelaxDeps = [ "pillow" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    ordered-set
    pillow
    sortedcollections
    setuptools-dso
  ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "tilequant" ];

  meta = with lib; {
    description = "Tool for quantizing image colors using tile-based palette restrictions";
    homepage = "https://github.com/SkyTemple/tilequant";
    changelog = "https://github.com/SkyTemple/tilequant/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
    mainProgram = "tilequant";
  };
}
