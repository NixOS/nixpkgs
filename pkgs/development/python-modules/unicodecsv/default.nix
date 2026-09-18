{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  version = "0.14.2";
  pname = "unicodecsv";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdunck";
    repo = "python-unicodecsv";
    tag = finalAttrs.version;
    hash = "sha256-LBYJ7evrcKj2WsWroflyQEhFkElp6zrmG9EDrp5+onM=";
  };

  build-system = [ setuptools ];

  # Uses unmaintained `unittest2` for testing
  doCheck = false;

  meta = {
    description = "Drop-in replacement for Python2's stdlib csv module, with unicode support";
    homepage = "https://github.com/jdunck/python-unicodecsv";
    maintainers = with lib.maintainers; [ koral ];
    license = lib.licenses.bsd2WithViews;
  };
})
