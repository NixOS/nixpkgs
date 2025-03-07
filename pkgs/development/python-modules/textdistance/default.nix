{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AeH7z3uHHrj0GRHZT0YbC5nPgAM4TuDhw0ylwaerLtA=";
  };

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "textdistance" ];

  meta = with lib; {
    description = "Python library for comparing distance between two or more sequences";
    homepage = "https://github.com/life4/textdistance";
    changelog = "https://github.com/life4/textdistance/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
