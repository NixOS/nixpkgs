{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-schema,
  zope-interface,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-filerepresentation";
<<<<<<< HEAD
  version = "7.0";
=======
  version = "6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.filerepresentation";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-VWi00b7m+aKwkg/Gfzo5fJWMqdMqgowBpkqsYcEO2gY=";
=======
    hash = "sha256-6J4munk2yyZ6e9rpU2Op+Gbf0OXGI6GpHjmpUZVRjsY=";
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
    zope-interface
    zope-schema
  ];

  pythonImportsCheck = [ "zope.filerepresentation" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "src/zope/filerepresentation" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.filerepresentation";
    description = "File-system Representation Interfaces";
    changelog = "https://github.com/zopefoundation/zope.filerepresentation/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
