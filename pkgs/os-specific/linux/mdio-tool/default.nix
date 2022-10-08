{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation {
  pname = "mdio-tool";
  # Will probably never update again
  version = "unstable-2019-02-06";

  src = fetchFromGitHub {
    owner = "linien-org";
    repo = "mdio-tool";
    rev = "72bd5a915ff046a59ce4303c8de672e77622a86c";
    sha256 = "sha256-NNLFmYzd1trh/9b90r+OdE/FloNQpMzsTgur49Ep4A0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "A tool to read and write MII registers from ethernet physicals under linux";
    homepage = "https://github.com/linien-org/mdio-tool";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.linux;
  };
}
