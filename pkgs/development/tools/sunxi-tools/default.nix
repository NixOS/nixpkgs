{ lib, stdenv, fetchFromGitHub, pkg-config, dtc, libusb1, zlib }:

stdenv.mkDerivation rec {
  pname = "sunxi-tools";
  version = "unstable-2021-08-29";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "74273b671a3fc34048383c40c85c684423009fb9";
    sha256 = "1gwamb64vr45iy2ry7jp1k3zc03q5sydmdflrbwr892f0ijh2wjl";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dtc libusb1 zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "tools" "misc" ];

  installTargets = [ "install-tools" "install-misc" ];

  meta = with lib; {
    description = "Tools for Allwinner SoC devices";
    homepage = "http://linux-sunxi.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elitak ];
  };
}
