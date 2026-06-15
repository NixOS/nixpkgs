{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xcffib,
  pillow,
}:

buildPythonPackage rec {
  pname = "xpybutil";
  version = "0.0.6";
  pyproject = true;

  # Pypi only offers a wheel
  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "xpybutil";
    rev = version;
    sha256 = "17gbqq955fcl29aayn8l0x14azc60cxgkvdxblz9q8x3l50w0xpg";
  };

  build-system = [ setuptools ];

  # pillow is a dependency in image.py which is not listed in setup.py
  dependencies = [
    pillow
    xcffib
  ];

  propagatedNativeBuildInputs = [ xcffib ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "xpybutil" ];

  meta = {
    homepage = "https://github.com/BurntSushi/xpybutil";
    description = "Incomplete xcb-util port plus some extras";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ artturin ];
  };
}
