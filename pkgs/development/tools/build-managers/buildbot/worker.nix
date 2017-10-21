{ stdenv, pythonPackages }:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot-worker";
  version = "0.9.11";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0lb8kwg3m9jgrww929d5nrjs4rj489mb4dnsdxcbdb358jbbym22";
  };

  buildInputs = with pythonPackages; [ setuptoolsTrial mock ];
  propagatedBuildInputs = with pythonPackages; [ twisted future ];

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    license = licenses.gpl2;
  };
})
