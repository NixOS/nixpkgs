{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  zope-i18nmessageid,
  zope-interface,
  zope-schema,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-configuration";
<<<<<<< HEAD
  version = "7.0";
=======
  version = "6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.configuration";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-G87VAEqMxF5Y3LuDJnDcOox5+ngJuRhUGSj9K8c3mYY=";
=======
    hash = "sha256-dkEVIHaXk/oP4uYYzI1hgSnPZXBMDjDu97zmOXnj9NA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
=======
      --replace-fail "setuptools < 74" "setuptools"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-i18nmessageid
    zope-interface
    zope-schema
  ];

  pythonImportsCheck = [ "zope.configuration" ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    cd $out/${python.sitePackages}/zope/
  '';

  unittestFlagsArray = [ "configuration/tests" ];

  pythonNamespaces = [ "zope" ];

<<<<<<< HEAD
  meta = {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = "https://github.com/zopefoundation/zope.configuration";
    changelog = "https://github.com/zopefoundation/zope.configuration/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
=======
  meta = with lib; {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = "https://github.com/zopefoundation/zope.configuration";
    changelog = "https://github.com/zopefoundation/zope.configuration/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
