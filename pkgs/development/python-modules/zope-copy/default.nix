{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zodbpickle,
  zope-interface,
  zope-location,
  zope-schema,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-copy";
  version = "5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.copy";
    tag = version;
    hash = "sha256-uQUvfZGrMvtClXa8tLKZFYehbcBIRx7WQnumUrdQjIk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools < 74" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    zodbpickle
    zope-interface
  ];

  pythonImportsCheck = [ "zope.copy" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-location
    zope-schema
  ];

  unittestFlagsArray = [
    "-s"
    "src/zope/copy"
  ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Pluggable object copying mechanism";
    homepage = "https://github.com/zopefoundation/zope.copy";
    changelog = "https://github.com/zopefoundation/zope.copy/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ ];
  };
}
