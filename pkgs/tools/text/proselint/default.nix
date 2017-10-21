{ stdenv, fetchurl, buildPythonApplication, click, future, six }:

buildPythonApplication rec {
  name = "proselint-${version}";
  version = "0.8.0";

  doCheck = false; # fails to pass because it tries to run in home directory

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${name}.tar.gz";
    sha256 = "1g8vx04gmv0agmggz1ml5vydfppqvl8dzjvqm6vqw5rzafa89m08";
  };

  propagatedBuildInputs = [ click future six ];

  meta = with stdenv.lib; {
    description = "A linter for prose";
    homepage = http://proselint.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ alibabzo ];
  };
}
