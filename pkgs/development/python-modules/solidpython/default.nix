{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, unittestCheckHook
, fetchPypi
, poetry-core

, euclid3
, ply
, prettytable
, pypng
, wcwidth
}:

buildPythonPackage rec {
  pname = "solidpython";
  version = "1.1.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GgH5msqAL9oKjyBX29mnvy7XsB4iX69UmPk7M3vEEsg=";
  };

  propagatedBuildInputs = [ prettytable euclid3 pypng ply wcwidth ];

  nativeBuildInputs = [ poetry-core pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "PrettyTable" "pypng" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  patches = [
    # Always run creation of dynamic test cases during module loading (allows using unittestCheckHook)
    ./unittest-setup.patch
  ];

  pythonImportsCheck = [ "solid" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python interface to the OpenSCAD declarative geometry language";
    homepage = "https://github.com/SolidCode/SolidPython";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ tmarkus ];
  };
}
