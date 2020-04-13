{ stdenv, fetchurl, buildPythonApplication, click, future, six }:

buildPythonApplication rec {
  pname = "proselint";
  version = "0.10.2";

  doCheck = false; # fails to pass because it tries to run in home directory

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${pname}-${version}.tar.gz";
    sha256 = "017risn0j1bjy9ygzfgphjnyjl4gk7wbrr4qv1vvrlan60wyp1rs";
  };

  propagatedBuildInputs = [ click future six ];

  meta = with stdenv.lib; {
    description = "A linter for prose";
    homepage = "http://proselint.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alibabzo ];
  };
}
