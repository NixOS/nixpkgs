{ lib, buildPythonPackage, isPy3k, fetchPypi
, mock
, meld3
, setuptools
}:

buildPythonPackage rec {
  pname = "supervisor";
  version = "4.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02pindhq84hb9a7ykyaqw8i2iqb21h69lpmclyqh7fm1446rji4n";
  };

  checkInputs = [ mock ];

  propagatedBuildInputs = [ meld3 setuptools ];

  meta = with lib; {
    description = "A system for controlling process state under UNIX";
    homepage = http://supervisord.org/;
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ zimbatm ];
  };
}
