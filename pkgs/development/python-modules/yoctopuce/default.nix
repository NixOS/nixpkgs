{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:
let
  pname = "yoctopuce";
  version = "2.1.5971";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i0kwl3hfg57d82jwva7xkqq1s2kngsrj81fcspca60j4znkwnn6";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [ "yoctopuce" ];

  meta = {
    homepage = "https://www.yoctopuce.com/EN/doc/reference/yoctolib-python-EN.html";
    changelog = "https://www.yoctopuce.com/EN/release_notes.php?sessionid=-1&file=YoctoLib.python.57762.zip";
    description = "Official Yoctopuce Library for Python";
    license = "See readme.md";
    maintainers = with lib.maintainers; [ bohreromir ];
  };
}
