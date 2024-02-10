{ lib
, buildPythonPackage
, fetchPypi
, click
, ordered-set
, pythonOlder
, pythonRelaxDepsHook
, pillow
, sortedcollections
, setuptools_dso
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

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pillow"
  ];

  propagatedBuildInputs = [
    click
    ordered-set
    pillow
    sortedcollections
    setuptools_dso
  ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [
    "tilequant"
  ];

  meta = with lib; {
    description = "Tool for quantizing image colors using tile-based palette restrictions";
    homepage = "https://github.com/SkyTemple/tilequant";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 xfix ];
  };
}
