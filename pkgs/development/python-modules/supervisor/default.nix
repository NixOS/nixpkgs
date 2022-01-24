{ stdenv, lib, buildPythonPackage, fetchPypi
, mock
, pytest
, setuptools
}:

buildPythonPackage rec {
  pname = "supervisor";
  version = "4.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40dc582ce1eec631c3df79420b187a6da276bbd68a4ec0a8f1f123ea616b97a2";
  };

  # wants to write to /tmp/foo which is likely already owned by another
  # nixbld user on hydra
  doCheck = !stdenv.isDarwin;
  checkInputs = [ mock pytest ];
  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "A system for controlling process state under UNIX";
    homepage = "http://supervisord.org/";
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ zimbatm ];
  };
}
