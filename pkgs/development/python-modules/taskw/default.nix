{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, tox
, six
, dateutil
, pytz
, pkgs
}:

buildPythonPackage rec {
  version = "1.0.3";
  pname = "taskw";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fa7bv5996ppfbryv02lpnlhk5dra63lhlwrb1i4ifqbziqfqh5n";
  };

  patches = [ ./use-template-for-taskwarrior-install-path.patch ];
  postPatch = ''
    substituteInPlace taskw/warrior.py \
      --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
  '';

  # https://github.com/ralphbean/taskw/issues/98
  doCheck = false;

  buildInputs = [ nose pkgs.taskwarrior tox ];
  propagatedBuildInputs = [ six dateutil pytz ];

  meta = with stdenv.lib; {
    homepage =  https://github.com/ralphbean/taskw;
    description = "Python bindings for your taskwarrior database";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pierron ];
  };

}
