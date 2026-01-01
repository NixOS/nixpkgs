{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-event";
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.event";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-1ZdhJwxzYsMT2s+z4MLR71cLFzIEmwE0KFilwg7BQ1E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

=======
    hash = "sha256-85jXSrploTcskdOBI84KGGf9Bno41ZTtT/TrbgmTxiA=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  pythonImportsCheck = [ "zope.event" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/event/tests.py" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Event publishing system";
    homepage = "https://github.com/zopefoundation/zope.event";
    changelog = "https://github.com/zopefoundation/zope.event/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
