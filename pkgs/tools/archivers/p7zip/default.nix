{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "p7zip-4.57";
  
  src = fetchurl {
    url = mirror://sourceforge/p7zip/p7zip_4.57_src_all.tar.bz2;
    sha256 = "0lsvw1bh6dzpxn8kyl7s79w2drpfxaa1c79khqm56gfmdlw27s80";
  };
  
  preConfigure = "
    makeFlagsArray=(DEST_HOME=$out)
  ";

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
  };
}
