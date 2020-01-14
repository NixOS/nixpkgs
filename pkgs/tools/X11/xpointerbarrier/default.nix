{ stdenv, xorg, fetchgit }:
stdenv.mkDerivation rec {
  pname = "xpointerbarrier";
  version = "18.06";
  src = fetchgit {
    url = "https://www.uninformativ.de/git/xpointerbarrier.git";
    rev = "v${version}";
    sha256 = "1k7i641x18qhjm0llsaqn2h2g9k31kgv6p8sildllmbvgxyrgvq7";
  };

  buildInputs = [ xorg.libX11 xorg.libXfixes xorg.libXrandr ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    homepage = https://uninformativ.de/git/xpointerbarrier;
    description = "Create X11 pointer barriers around your working area";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.xzfc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
