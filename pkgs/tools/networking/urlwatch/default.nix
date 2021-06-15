{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "urlwatch";
  version = "2.23";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "urlwatch";
    rev = version;
    sha256 = "1ryygy7lalmwnv9kc8q4920gkdx878izy33a5dgxb780sy2qq8pg";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cssselect
    keyring
    lxml
    markdown2
    matrix-client
    minidb
    pushbullet
    pycodestyle
    pyppeteer
    pyyaml
    requests
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
