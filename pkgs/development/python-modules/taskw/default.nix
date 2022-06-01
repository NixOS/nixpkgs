{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, substituteAll
, taskwarrior
, python-dateutil
, pytz
, kitchen
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "taskw";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1109bdf9bde7a9b32a5007a302c878303ff65188b64225ac74a3289a4c548bdd";
  };

  patches = [
    (substituteAll {
      src = ./use-template-for-taskwarrior-install-path.patch;
      inherit taskwarrior;
    })
  ];

  buildInputs = [
    taskwarrior
  ];

  propagatedBuildInputs = [
    python-dateutil
    pytz
    kitchen
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/ralphbean/taskw";
    description = "Python bindings for your taskwarrior database";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pierron ];
  };
}
