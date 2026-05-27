{
  lib,
  buildPythonPackage,
  cmake,
  setuptools,
  xrootd,
}:

buildPythonPackage rec {
  pname = "xrootd";
  pyproject = true;

  inherit (xrootd) version src;

  sourceRoot = "${src.name}/bindings/python";

  build-system = [
    cmake
    setuptools
  ];

  buildInputs = [ xrootd ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "XRootD" ];

  # Tests are only compatible with Python 2
  doCheck = false;

  meta = {
    description = "XRootD central repository";
    homepage = "https://github.com/xrootd/xrootd";
    changelog = "https://github.com/xrootd/xrootd/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
