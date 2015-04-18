{stdenv, fetchurl, zlib}:
let
  s = # Generated upstream information
  rec {
    baseName="advancecomp";
    version="1.19";
    name="${baseName}-${version}";
    url="http://prdownloads.sourceforge.net/advancemame/advancecomp-1.19.tar.gz?download";
    sha256="0irhmwcn9r4jc29442skqr1f3lafiaahxc3m3ybalmm37l6cb56m";
  };
  buildInputs = [
    zlib
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''A set of tools to optimize deflate-compressed files'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    updateWalker = true;
    homepage = "http://advancemame.sourceforge.net/comp-readme.html";
    downloadPage = "http://advancemame.sourceforge.net/comp-download.html";
  };
}
