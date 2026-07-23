{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-jinjadomain";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-frzcrUnJna8wmKbsC7wduazLSZ8lzOKOCf75Smk675E=";
  };

  prePatch = ''
    substituteInPlace sphinxcontrib/jinjadomain.py \
      --replace-fail "content.sort(key=lambda (k, v): k)" "content.sort(key=lambda kv: kv[0])"
  '';

  build-system = [ setuptools ];

  dependencies = [ sphinx ];

  pythonImportsCheck = [ "sphinxcontrib.jinjadomain" ];

  meta = {
    description = "Sphinx domain for describing jinja templates";
    homepage = "https://github.com/offlinehacker/sphinxcontrib.jinjadomain";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "sphinxcontrib-jinjadomain";
  };
}
