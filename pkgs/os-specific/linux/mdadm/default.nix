{stdenv, fetchurl, groff}:

stdenv.mkDerivation {
  name = "mdadm-2.6";
  src = fetchurl {
    url = http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-2.6.tgz;
    md5 = "15019078eacc8c21eac7b0b7faf86129";
  };

  buildInputs = [groff];

  preBuild = "
    makeFlags=\"INSTALL=install BINDIR=$out/sbin MANDIR=$out/share/man\"
  ";

  meta = {
    description = "Programs for managing RAID arrays under Linux";
  };
}
