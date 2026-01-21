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
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "tracerite";
    tag = "v${version}";
    hash = "sha256-UXIQc5rXVaZuZj5xu2X9H38vKWAM+AoKrKfudovUhwA=";
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
