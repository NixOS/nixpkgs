{ stdenv, lib, buildPythonPackage, isPy3k, fetchPypi
, mock
, meld3
, pytest
, setuptools
}:

buildPythonPackage rec {
  pname = "supervisor";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dc86fe0476e945e61483d614ceb2cf4f93b95282eb243bdf792621994360383";
  };

  # wants to write to /tmp/foo which is likely already owned by another
  # nixbld user on hydra
  doCheck = !stdenv.isDarwin;
  checkInputs = [ mock pytest ];
  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [ meld3 setuptools ];

  meta = with lib; {
    description = "A system for controlling process state under UNIX";
    homepage = http://supervisord.org/;
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ zimbatm ];
  };
}
