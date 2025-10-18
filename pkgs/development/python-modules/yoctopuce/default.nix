{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:
let
  pname = "yoctopuce";
  version = "2.1.6320";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6NMjHWBmTd3ZatSV7kOMK4A034pFFio/FZbEg4+Lyhs=";
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
