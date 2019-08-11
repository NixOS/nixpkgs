{ lib, buildPythonPackage, isPy3k, fetchPypi
, mock
, meld3
}:
buildPythonPackage rec {
  pname = "supervisor";
  version = "3.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w3ahridzbc6rxfpbyx8lij6pjlcgf2ymzyg53llkjqxalp6sk8v";
  };

  checkInputs = [ mock ];

  propagatedBuildInputs = [ meld3 ];

  # Supervisor requires Python 2.4 or later but does not work on any version of Python 3.  You are using version 3.6.5 (default, Mar 28 2018, 10:24:30)
  disabled = isPy3k;

  meta = {
    description = "A system for controlling process state under UNIX";
    homepage = http://supervisord.org/;
    license = lib.licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
