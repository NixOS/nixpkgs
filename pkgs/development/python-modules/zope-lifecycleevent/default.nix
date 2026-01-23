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
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.lifecycleevent";
    tag = version;
    hash = "sha256-HgxOUseRYc+mkwESUDqauoH2D2E4PL8XxM1C0FC35w8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
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
