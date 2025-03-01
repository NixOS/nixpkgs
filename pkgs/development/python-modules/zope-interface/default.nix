{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zope-interface";
  version = "7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.interface";
    tag = version;
    hash = "sha256-WrS/YHkEmV1G/Scg0xpyu2uFVWTWnEpajqNDvGioVgc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools < 74" "setuptools"
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zope.interface" ];

  doCheck = false; # Circular deps.

  pythonNamespaces = [ "zope" ];

  meta = {
    changelog = "https://github.com/zopefoundation/zope.interface/blob/${version}/CHANGES.rst";
    description = "Zope.Interface";
    homepage = "https://github.com/zopefoundation/zope.interface";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
