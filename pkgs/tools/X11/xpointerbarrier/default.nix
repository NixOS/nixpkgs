{ stdenv, xorg, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "xpointerbarrier-${version}";
  version = "17.11";

  src = fetchFromGitHub {
    owner = "vain";
    repo = "xpointerbarrier";
    rev = "v${version}";
    sha256 = "0s6bd58xjyc2nqzjq6aglx6z64x9xavda3i6p8vrmxqmcpik54nm";
  };

  buildInputs = [ xorg.libX11 xorg.libXfixes xorg.libXrandr ];

  makeFlags = "prefix=$(out)";

  meta = {
    homepage = https://github.com/vain/xpointerbarrier;
    description = "Create X11 pointer barriers around your working area";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.xzfc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
