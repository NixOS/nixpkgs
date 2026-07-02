{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "syslog-rfc5424-formatter";
  version = "1.2.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "easypost";
    repo = "syslog-rfc5424-formatter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dvRSOMXRmZf0vEEyX6H7OBSfo/PgyOLKuDS8X6g4qe0=";
  };

  build-system = [
    setuptools
  ];

  # Tests depend on syslog_rfc5424_parser, which we don't package
  doCheck = false;

  pythonImportsCheck = [ "syslog_rfc5424_formatter" ];

  meta = {
    description = "Python logging formatter for emitting RFC5424 Syslog messages";
    homepage = "https://github.com/easypost/syslog-rfc5424-formatter";
    changelog = "https://github.com/EasyPost/syslog-rfc5424-formatter/blob/v${finalAttrs.version}/CHANGES.md";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
