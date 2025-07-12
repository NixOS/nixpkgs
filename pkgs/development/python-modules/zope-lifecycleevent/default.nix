{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-event,
  zope-interface,
  unittestCheckHook,
  zope-component,
  zope-testing,
}:

buildPythonPackage rec {
  pname = "zope-lifecycleevent";
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.lifecycleevent";
    tag = version;
    hash = "sha256-vTonbZSeQxnLA6y1wAnBpobEKAs+gaAYN25dx5Fla9k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-interface
  ];

  pythonImportsCheck = [
    "zope.lifecycleevent"
    "zope.interface"
  ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-component
    zope-testing
  ];

  unittestFlagsArray = [ "src/zope/lifecycleevent" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.lifecycleevent";
    description = "Object life-cycle events";
    changelog = "https://github.com/zopefoundation/zope.lifecycleevent/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
