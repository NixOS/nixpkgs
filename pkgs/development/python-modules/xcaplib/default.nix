{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  twisted,
  python3-application,
}:

buildPythonPackage (finalAttrs: {
  pname = "xcaplib";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-xcaplib";
    tag = finalAttrs.version;
    hash = "sha256-/htvXj9rLlJxcgJoUh4OG8PcCVIJ46ghzzqLZicONVc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lxml
    twisted
    python3-application
  ];

  # the one and only upstream test relies on networking
  doCheck = false;

  pythonImportsCheck = [ "xcaplib" ];

  meta = {
    description = "XCAP (RFC4825) client library";
    homepage = "https://github.com/AGProjects/python3-xcaplib";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.ngi ];
    maintainers = [ lib.maintainers.ethancedwards8 ];
    mainProgram = "xcapclient3";
  };
})
