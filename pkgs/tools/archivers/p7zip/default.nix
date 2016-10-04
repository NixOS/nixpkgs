{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "p7zip-${version}";
  version = "16.02";

  src = fetchurl {
    url = "mirror://sourceforge/p7zip/p7zip_${version}_src_all.tar.bz2";
    sha256 = "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f";
  };

  preConfigure = ''
    makeFlagsArray=(DEST_HOME=$out)
    buildFlags=all3
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    cp makefile.macosx_llvm_64bits makefile.machine
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
    # license = stdenv.lib.licenses.lgpl21Plus; + "unRAR restriction"
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}
