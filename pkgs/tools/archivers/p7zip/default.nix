{ stdenv, fetchurl }:

let
  version = "15.14.1";
in
stdenv.mkDerivation rec {
  name = "p7zip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/p7zip/p7zip_${version}_src_all.tar.bz2";
    sha256 = "1m15iwglyjpiw82m7dbpykz8s55imch34w20w09l34116vdb97b9";
  };

  preConfigure = ''
    makeFlagsArray=(DEST_HOME=$out)
    buildFlags=all3
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    cp makefile.macosx_64bits makefile.machine
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
