{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:
let
  pname = "yoctopuce";
  version = "2.1.12413";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-26lzhld8LfPwMpB+Hn0F8rJDMCpmpcWwIQ/9zRSs6x0=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [ "yoctopuce" ];

  meta = {
    homepage = "https://www.yoctopuce.com/EN/doc/reference/yoctolib-python-EN.html";
    changelog = "https://www.yoctopuce.com/EN/release_notes.php?sessionid=-1&file=YoctoLib.python.57762.zip";
    description = "Official Yoctopuce Library for Python";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ bohreromir ];
  };
}
