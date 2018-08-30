{ stdenv, python3Packages }:

python3Packages.buildPythonApplication (rec {
  pname = "buildbot-worker";
  version = "1.3.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1l9iqyqn9yln6ln6dhfkngzx92a61v1cf5ahqj4ax663i02yq7fh";
  };

  buildInputs = with python3Packages; [ setuptoolsTrial mock ];
  propagatedBuildInputs = with python3Packages; [ twisted future ];

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
