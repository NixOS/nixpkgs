{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  html5tagger,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "tracerite";
  version = "1.1.3";
  format = "setuptools";

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

  meta = {
    description = "Tracebacks for Humans in Jupyter notebooks";
    homepage = "https://github.com/sanic-org/tracerite";
    changelog = "https://github.com/sanic-org/tracerite/releases/tag/${src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ p0lyw0lf ];
  };
}
