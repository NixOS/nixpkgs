{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  html5tagger,
  setuptools,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tracerite";
  version = "1.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "tracerite";
    tag = "v${version}";
    hash = "sha256-T210vRXFWlTs5ke13DVvZEVsonXiT+g6xSI63+DxLXc=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    html5tagger
  ];

  postInstall = ''
    cp tracerite/style.css $out/${python.sitePackages}/tracerite
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "tracerite" ];

  meta = with lib; {
    description = "Tracebacks for Humans in Jupyter notebooks";
    homepage = "https://github.com/sanic-org/tracerite";
    changelog = "https://github.com/sanic-org/tracerite/releases/tag/${src.tag}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ p0lyw0lf ];
  };
}
