{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
let
  pname = "yoctopuce";
  version = "2.1.5971";
  format = "wheel";
in
buildPythonPackage {
  inherit pname version format;

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1k4g9saji62yn0nz3pmj0wk1msari2j5sh02pk9sdjhp6kbl8fm8";
  };

  pythonImportsCheck = [ "yoctopuce" ];

  meta = {
    homepage = "https://www.yoctopuce.com/EN/doc/reference/yoctolib-python-EN.html";
    changelog = "https://www.yoctopuce.com/EN/release_notes.php?sessionid=-1&file=YoctoLib.python.57762.zip";
    description = "Official Yoctopuce Library for Python";
    license = "See readme.md";
    maintainers = with lib.maintainers; [ bohreromir ];
  };
}
