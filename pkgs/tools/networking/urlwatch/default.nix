{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.17";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "1865p3yczgpq8gvgh4cpgbx2ibc1fwycd7pagga9sj8r3q0giqyk";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cssselect
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
