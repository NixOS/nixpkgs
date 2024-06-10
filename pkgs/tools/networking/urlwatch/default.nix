{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "urlwatch";
  version = "2.28";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "urlwatch";
    rev = version;
    hash = "sha256-dGohG2+HrsuKegPAn1fmpLYPpovEEUsx+C/0sp2/cX0=";
  };

  patches = [
    # lxml 5 compatibility fix
    # FIXME: remove in next release
    (fetchpatch {
      url = "https://github.com/thp/urlwatch/commit/123de66d019aef7fc18fab6d56cc2a54d81fea3f.patch";
      excludes = [ "CHANGELOG.md" ];
      hash = "sha256-C9qb6TYeNcdszunE2B5DWRyXyqnANd32H7m9KmidCD0=";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cssselect
    jq
    keyring
    lxml
    markdown2
    matrix-client
    minidb
    playwright
    pushbullet-py
    pycodestyle
    pyyaml
    requests
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Tool for monitoring webpages for updates";
    mainProgram = "urlwatch";
    homepage = "https://thp.io/2008/urlwatch/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kmein tv ];
  };
}
