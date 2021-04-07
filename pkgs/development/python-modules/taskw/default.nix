{ lib
, buildPythonPackage
, fetchPypi
, nose
, tox
, six
, dateutil
, kitchen
, pytz
, pkgs
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "taskw";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7673d80b3d5bace5b35eb71f5035e313a92daab6e437694128d8ce7dcdaf66fb";
  };

  patches = [ ./use-template-for-taskwarrior-install-path.patch ];
  postPatch = ''
    substituteInPlace taskw/warrior.py \
      --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
  '';

  # https://github.com/ralphbean/taskw/issues/98
  doCheck = false;

  buildInputs = [ nose pkgs.taskwarrior tox ];
  propagatedBuildInputs = [ six dateutil kitchen pytz ];

  meta = with lib; {
    homepage =  "https://github.com/ralphbean/taskw";
    description = "Python bindings for your taskwarrior database";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pierron ];
  };

}
