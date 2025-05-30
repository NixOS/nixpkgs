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
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "tracerite";
    tag = "v${version}";
    hash = "sha256-rI1MNdYl/P64tUHyB3qV9gfLbGbCVOXnEFoqFTkaqgg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    html5tagger
    setuptools
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
    changelog = "https://github.com/sanic-org/tracerite/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ p0lyw0lf ];
  };
}
