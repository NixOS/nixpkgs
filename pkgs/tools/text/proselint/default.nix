{ stdenv, fetchurl, buildPythonApplication, click, future, six }:

buildPythonApplication rec {
  name = "proselint-${version}";
  version = "0.10.0";

  doCheck = false; # fails to pass because it tries to run in home directory

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${name}.tar.gz";
    sha256 = "0kmr95mf2gij40qy4660ryfanw13vxlhpmivqia1mdbii8iziyhg";
  };

  propagatedBuildInputs = [ click future six ];

  meta = with stdenv.lib; {
    description = "A linter for prose";
    homepage = http://proselint.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ alibabzo ];
  };
}
