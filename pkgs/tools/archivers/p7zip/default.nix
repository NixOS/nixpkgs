{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "p7zip-4.53";
  
  src = fetchurl {
    url = mirror://sourceforge/p7zip/p7zip_4.53_src_all.tar.bz2;
    sha256 = "0pbgvpq852qnzq4isgc13p4nnp416xhy5vmn1rcwm8fk43l5rbqd";
  };
  
  preConfigure = "
    makeFlagsArray=(DEST_HOME=$out)
  ";

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
  };
}
