{ lib, buildPythonPackage, fetchFromGitHub, xcffib, pillow }:

buildPythonPackage rec {
  pname = "xpybutil";
  version = "0.0.6";

  # Pypi only offers a wheel
  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "17gbqq955fcl29aayn8l0x14azc60cxgkvdxblz9q8x3l50w0xpg";
  };

  # pillow is a dependency in image.py which is not listed in setup.py
  propagatedBuildInputs = [ xcffib pillow ];

  meta = with lib; {
    homepage = "https://github.com/BurntSushi/xpybutil";
    description = "An incomplete xcb-util port plus some extras";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ artturin ];
  };
}
