{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.14";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "1m7qdh2lk5napncmfnk86dj4wqcahq8y24xnylxa4qlx2ivwkr6b";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    keyring
    lxml
    minidb
    pycodestyle
    pyyaml
    requests
  ];

  meta = with stdenv.lib; {
    description = "A tool for monitoring webpages for updates";
    homepage = https://thp.io/2008/urlwatch/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ tv ];
  };
}
