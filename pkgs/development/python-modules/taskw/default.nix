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
  version = "1.3.1";
  pname = "taskw";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a68e49cac2d4f6da73c0ce554fd6f94932d95e20596f2ee44a769a28c12ba7d";
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
