{ lib
, buildPythonPackage
, fetchPypi
, nose
, tox
, six
, python-dateutil
, kitchen
, pytestCheckHook
, pytz
, pkgs
}:

buildPythonPackage rec {
  pname = "taskw";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EQm9+b3nqbMqUAejAsh4MD/2UYi2QiWsdKMomkxUi90=";
  };

  patches = [ ./use-template-for-taskwarrior-install-path.patch ];
  postPatch = ''
    substituteInPlace taskw/warrior.py \
      --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
  '';

  buildInputs = [ pkgs.taskwarrior ];

  propagatedBuildInputs = [ six python-dateutil kitchen pytz ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage =  "https://github.com/ralphbean/taskw";
    description = "Python bindings for your taskwarrior database";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pierron ];
  };
}
