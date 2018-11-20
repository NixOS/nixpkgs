{ lib
, buildPythonApplication
, fetchFromGitHub
, beautifulsoup4
, boto3
, configparser
, keyring
, keyrings-alt
, lxml
, pillow
, requests
, six
, tabulate
, tzlocal
, nose
, mock
, withU2F ? false, python-u2flib-host
}:

buildPythonApplication rec {
  pname = "aws-google-auth";
  version = "0.0.29";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  # https://github.com/cevoaustralia/aws-google-auth/issues/120
  src = fetchFromGitHub {
    owner = "cevoaustralia";
    repo = "aws-google-auth";
    rev = version;
    sha256 = "06dalrwjy1sbc5wvj5ip4h999izlb0j5g6b6f3l5znnsm0vfvfia";
  };

  propagatedBuildInputs = [ 
    beautifulsoup4
    boto3
    configparser
    keyring
    keyrings-alt
    lxml
    pillow
    requests
    six
    tabulate
    tzlocal
  ] ++ lib.optional withU2F python-u2flib-host;
  
  checkInputs = [ 
    mock
    nose 
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Acquire AWS STS (temporary) credentials via Google Apps SAML Single Sign On";
    homepage = https://github.com/cevoaustralia/aws-google-auth;
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
