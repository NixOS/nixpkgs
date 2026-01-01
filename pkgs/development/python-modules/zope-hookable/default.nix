{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-hookable";
<<<<<<< HEAD
  version = "8.0";
=======
  version = "7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.hookable";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-5ps/H9bL2oN9IHxXzpWw/9uMLhwV+OpQ26kXlsP4hgw=";
=======
    hash = "sha256-qJJc646VSdNKors6Au4UAGvm7seFbvjEfpdqf//vJNE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
=======
      --replace-fail "setuptools<74" "setuptools"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zope.hookable" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "src/zope/hookable/tests" ];

  pythonNamespaces = [ "zope" ];

<<<<<<< HEAD
  meta = {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    changelog = "https://github.com/zopefoundation/zope.hookable/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
=======
  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    changelog = "https://github.com/zopefoundation/zope.hookable/blob/${src.tag}/CHANGES.rst";
    license = licenses.zpl21;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
