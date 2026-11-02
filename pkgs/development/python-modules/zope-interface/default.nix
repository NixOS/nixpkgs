{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zope-interface";
  version = "8.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.interface";
    tag = version;
    hash = "sha256-VIK5FiYpsF6mSWFiK5beZHcZ3Fkno5YDiceWbwGNauE=";
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
