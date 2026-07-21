{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-asciinema-player";
  version = "2.6.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-asciinema-player";
    inherit (finalAttrs) version;
    hash = "sha256-yA6WC067St82Dm6StaCKdWrRBhmNemswetIO8iodfcw=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "xstatic.pkg.asciinema_player" ];

  meta = {
    homepage = "https://github.com/xstatic-py/xstatic-asciinema-player";
    description = "Asciinema-player packaged for python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aither64 ];
  };
})
