{ stdenv, python3Packages, fetchFromGitLab }:

with python3Packages;

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "fsfe-reuse";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qwwzlm2fnw88m0xs0v61l46vlfhwyih1s6bj7fg4ivhjcgz0hq7";
  };

  propagatedBuildInputs = with python3Packages; [ chardet debian pygit2 ];

  checkInputs = with python3Packages; [ tox ];

  # needs tox
  doCheck = false;

  meta = with stdenv.lib; {
    description = "reuse is a tool for compliance with the REUSE Initiative recommendations.";
    homepage = "https://reuse.gitlab.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kirelagin ];
  };
}
