{ stdenv, fetchurl, perl, AlgorithmDiff, RegexpCommon }:

stdenv.mkDerivation rec {
  
  name = "cloc-${version}";

  version = "1.58";

  src = fetchurl {
    url = "mirror://sourceforge/cloc/cloc-${version}.tar.gz";
    sha256 = "1k92jldy4m717lh1xd6yachx3l2hhpx76qhj1ipnx12hsxw1zc8w";
  };

  buildInputs = [ perl AlgorithmDiff RegexpCommon ];

  unpackPhase = ''
    mkdir ${name}
    tar xf $src -C ${name}
    cd ${name}
  '';

  makeFlags = [ "prefix=" "DESTDIR=$(out)" "INSTALL=install" ];

  meta = {
    description = "A program that counts lines of source code";
    homepage = http://cloc.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
  };

}
