{ lib
, fetchFromGitHub
, python3Packages
, tesseract

, variant ? "small"

, withPushbulletReporter ? variant == "full"
, withMatrixReporter ? variant == "full"
, withColoredStdoutReporter ? variant == "full"
, withXMPPReporter ? variant == "full"

, withOCRFilter ? variant == "full"
, withPdf2textFilter ? variant == "full"
, withHtml2textFilter ? variant == "full"
, withBeautifyFilter ? variant == "full"
, withJqFilter ? variant == "full"
}:

assert lib.elem variant [ "full" "small" ];

python3Packages.buildPythonApplication rec {
  pname = "urlwatch";
  version = "2.28";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "urlwatch";
    rev = version;
    hash = "sha256-dGohG2+HrsuKegPAn1fmpLYPpovEEUsx+C/0sp2/cX0=";
  };

  buildInputs = lib.optional withOCRFilter tesseract;

  propagatedBuildInputs = (with python3Packages; [
    appdirs
    cssselect
    keyring
    lxml
    minidb
    pyppeteer
    pyyaml
    requests
  ] ++ lib.optionals withOCRFilter [ pytesseract pillow ]
    ++ lib.optional withPdf2textFilter pdftotext
    ++ lib.optional (withHtml2textFilter || withBeautifyFilter) beautifulsoup4
    ++ lib.optional withJqFilter jq
    ++ lib.optional withPushbulletReporter pushbullet-py
    ++ lib.optionals withMatrixReporter [ markdown2 matrix-client ]
    ++ lib.optional withColoredStdoutReporter colorama
    ++ lib.optional withXMPPReporter aioxmpp
  );

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A tool for monitoring webpages for updates";
    homepage = "https://thp.io/2008/urlwatch/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kmein tv ];
  };
}
