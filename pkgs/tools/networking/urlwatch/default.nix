{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "urlwatch";
  version = "2.21";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "1s6bigkwymxdp9bkgvwg3lbf465i6k8kmak2w7czf4mhwavcfq63";
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
    pyppeteer
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A tool for monitoring webpages for updates";
    homepage = "https://thp.io/2008/urlwatch/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kmein tv ];
  };
}
