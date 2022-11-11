{ lib
, buildPythonPackage
, fetchPypi
, nose
, tox
, six
, python-dateutil
, kitchen
, pytz
, pkgs
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "taskw";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EQm9+b3nqbMqUAejAsh4MD/2UYi2QiWsdKMomkxUi90=";
  };

  patches = [ ./use-template-for-taskwarrior-install-path.patch ];
  postPatch = ''
    substituteInPlace taskw/warrior.py \
      --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
  '';

  # https://github.com/ralphbean/taskw/issues/98
  doCheck = false;

  buildInputs = [ nose pkgs.taskwarrior tox ];
  propagatedBuildInputs = [ six python-dateutil kitchen pytz ];

  meta = with lib; {
    homepage =  "https://github.com/ralphbean/taskw";
    description = "Python bindings for your taskwarrior database";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pierron ];
  };

}
