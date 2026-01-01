{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  zope-proxy,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-deferredimport";
<<<<<<< HEAD
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.deferredimport";
    tag = version;
    hash = "sha256-7Q8+Cew5987+CjUOxqpwMFXWdw+/B28tOEXRYC0SRyI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

=======
  version = "5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.deferredimport";
    inherit version;
    hash = "sha256-Orvw4YwfF2WRTs0dQbVJ5NBFshso5AZfsMHeCtc2ssM=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  dependencies = [ zope-proxy ];

  pythonImportsCheck = [ "zope.deferredimport" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "src/zope/deferredimport" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Allows you to perform imports names that will only be resolved when used in the code";
    homepage = "https://github.com/zopefoundation/zope.deferredimport";
    changelog = "https://github.com/zopefoundation/zope.deferredimport/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
  };
}
