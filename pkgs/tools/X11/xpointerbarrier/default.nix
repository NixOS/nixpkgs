{ stdenv, xorg, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "xpointerbarrier-${version}";
  version = "17.10";

  src = fetchFromGitHub {
    owner = "vain";
    repo = "xpointerbarrier";
    rev = "v${version}";
    sha256 = "0p4qc7ggndf74d2xdf38659prx3r3lfi5jc8nmqx52c9fqdshcrk";
  };

  buildInputs = [ xorg.libX11 xorg.libXfixes xorg.libXrandr ];

  makeFlags = "prefix=$(out)";

  meta = {
    homepage = https://github.com/vain/xpointerbarrier;
    description = "Create X11 pointer barriers around your working area";
    license = stdenv.lib.licenses.mit;
    maintainers = stdenv.lib.maintainers.xzfc;
    platforms = stdenv.lib.platforms.linux;
  };
}
