{
  lib,
  buildPythonPackage,
  cmake,
  setuptools,
  wheel,
  xrootd,
}:

buildPythonPackage rec {
  pname = "xrootd";
  pyproject = true;

  inherit (xrootd) version src;

  sourceRoot = "${src.name}/bindings/python";

  nativeBuildInputs = [
    cmake
    setuptools
    wheel
  ];

  buildInputs = [ xrootd ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "XRootD" ];

  # Tests are only compatible with Python 2
  doCheck = false;

  meta = with lib; {
    description = "The XRootD central repository";
    homepage = "https://github.com/xrootd/xrootd";
    changelog = "https://github.com/xrootd/xrootd/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
