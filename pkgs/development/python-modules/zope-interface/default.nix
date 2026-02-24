{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zope-interface";
  version = "8.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.interface";
    tag = version;
    hash = "sha256-IYtfd9mJLcwk3FGPWlD5PbrKdIwDQf1Thn6fWFa5Rpo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zope.interface" ];

  doCheck = false; # Circular deps.

  pythonNamespaces = [ "zope" ];

  meta = {
    changelog = "https://github.com/zopefoundation/zope.interface/blob/${src.tag}/CHANGES.rst";
    description = "Implementation of object interfaces, a mechanism for labeling objects as conforming to a given API or contract";
    homepage = "https://github.com/zopefoundation/zope.interface";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
