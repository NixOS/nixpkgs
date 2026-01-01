{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-event,
  zope-interface,
  unittestCheckHook,
  zope-i18nmessageid,
}:

buildPythonPackage rec {
  pname = "zope-schema";
<<<<<<< HEAD
  version = "8.1";
=======
  version = "7.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.schema";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-pO3yL0gej2PGD01ySiPJPU66P/9hW73T2n/ZnUPa3C0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

=======
    hash = "sha256-aUjlSgMfoKQdE0ta8jxNjh+L7OKkfOVvUWnvhx+QRsI=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-interface
  ];

  pythonImportsCheck = [ "zope.schema" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-i18nmessageid
  ];

  unittestFlagsArray = [ "src/zope/schema/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.schema";
    description = "zope.interface extension for defining data schemas";
    changelog = "https://github.com/zopefoundation/zope.schema/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
