{ stdenv
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
  version = "1.2.0";
  pname = "taskw";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fadd8afc12df026c3c2d39b633c55d3337f7dca95602fce2239455a048bc85fe";
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

  meta = with stdenv.lib; {
    homepage =  https://github.com/ralphbean/taskw;
    description = "Python bindings for your taskwarrior database";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pierron ];
  };

}
