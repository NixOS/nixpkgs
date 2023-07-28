{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, html5tagger
, python
}:

buildPythonPackage rec {
  pname = "tracerite";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "tracerite";
    rev = "v${version}";
    hash = "sha256-At8wVR3EcHEi051BBfjb+sOhs93GyzWlEAjtehTMeNU=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    html5tagger
  ];

  postInstall = ''
    cp tracerite/style.css $out/${python.sitePackages}/tracerite
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "tracerite"
  ];

  meta = with lib; {
    description = "Tracebacks for Humans (in Jupyter notebooks";
    homepage = "https://github.com/sanic-org/tracerite";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
  };
}
