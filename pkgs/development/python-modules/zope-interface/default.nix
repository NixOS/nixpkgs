{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zope-interface";
<<<<<<< HEAD
  version = "8.0.1";
=======
  version = "7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.interface";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-IYtfd9mJLcwk3FGPWlD5PbrKdIwDQf1Thn6fWFa5Rpo=";
  };

=======
    hash = "sha256-WrS/YHkEmV1G/Scg0xpyu2uFVWTWnEpajqNDvGioVgc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools < 74" "setuptools"
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  pythonImportsCheck = [ "zope.interface" ];

  doCheck = false; # Circular deps.

  pythonNamespaces = [ "zope" ];

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/zopefoundation/zope.interface/blob/${src.tag}/CHANGES.rst";
    description = "Implementation of object interfaces, a mechanism for labeling objects as conforming to a given API or contract";
=======
    changelog = "https://github.com/zopefoundation/zope.interface/blob/${version}/CHANGES.rst";
    description = "Zope.Interface";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/zopefoundation/zope.interface";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
