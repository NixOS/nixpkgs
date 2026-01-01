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
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.lifecycleevent";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-HgxOUseRYc+mkwESUDqauoH2D2E4PL8XxM1C0FC35w8=";
=======
    hash = "sha256-vTonbZSeQxnLA6y1wAnBpobEKAs+gaAYN25dx5Fla9k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
=======
      --replace-fail "setuptools <= 75.6.0" setuptools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
