{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.15";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "1bkd0r5arzdvinpn1n23cw1gf7byxml95hl6qvvf6mnggb1ifcwg";
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
