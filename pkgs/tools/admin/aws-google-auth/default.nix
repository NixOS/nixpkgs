{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  beautifulsoup4,
  boto3,
  configparser,
  filelock,
  keyring,
  keyrings-alt,
  lxml,
  pillow,
  requests,
  six,
  tabulate,
  tzlocal,
  nose,
  mock,
  setuptools,
  aws-google-auth,
  testers,
  withU2F ? false,
  python-u2flib-host,
}:

buildPythonApplication rec {
  pname = "aws-google-auth";
  version = "0.0.38";

  pyproject = true;

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  # https://github.com/cevoaustralia/aws-google-auth/issues/120
  src = fetchFromGitHub {
    owner = "cevoaustralia";
    repo = "aws-google-auth";
    rev = "refs/tags/${version}";
    sha256 = "sha256-/Xe4RDA9sBEsBBV1VP91VX0VfO8alK8L70m9WrB7qu4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    boto3
    configparser
    filelock
    keyring
    keyrings-alt
    lxml
    pillow
    requests
    six
    tabulate
    tzlocal
  ] ++ lib.optional withU2F python-u2flib-host;

  nativeCheckInputs = [
    mock
    nose
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  # with pyproject the tests aren't attempted
  # without pyproject the tests try to access internet
  doCheck = false;

  pythonImportsCheck = [ "aws_google_auth" ];

  passthru.tests.version = testers.testVersion {
    package = aws-google-auth;
  };

  meta = with lib; {
    description = "Acquire AWS STS (temporary) credentials via Google Apps SAML Single Sign On";
    mainProgram = "aws-google-auth";
    homepage = "https://github.com/cevoaustralia/aws-google-auth";
    maintainers = [ ];
    license = licenses.mit;
  };
}
