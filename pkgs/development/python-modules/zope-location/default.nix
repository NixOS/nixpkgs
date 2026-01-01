{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
  zope-proxy,
  zope-schema,
  zope-component,
  zope-configuration,
<<<<<<< HEAD
  zope-copy,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-location";
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.location";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-s7HZda+U87P62elX/KbDp2o9zAplgFVmnedDI/uq2sk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

=======
    hash = "sha256-C8tQ4qqzkQx+iU+Pm3iCEchtqOZT/qcYFSzJWzqlhnI=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-proxy
    zope-schema
  ];

  optional-dependencies = {
    zcml = [ zope-configuration ];
    component = [ zope-component ];
<<<<<<< HEAD
    copy = [ zope-copy ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonImportsCheck = [ "zope.location" ];

  nativeCheckInputs = [ unittestCheckHook ];

<<<<<<< HEAD
=======
  # prevent cirtular import
  preCheck = ''
    rm src/zope/location/tests/test_configure.py
    rm src/zope/location/tests/test_pickling.py
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  unittestFlagsArray = [ "src/zope/location/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.location/";
    description = "Zope Location";
    changelog = "https://github.com/zopefoundation/zope.location/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
