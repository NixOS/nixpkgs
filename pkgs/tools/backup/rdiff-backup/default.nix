{stdenv, fetchurl, python, librsync, gnused }:

stdenv.mkDerivation {
  name = "rdiff-backup-1.1.14";

  src = fetchurl {
    url = http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.1.14.tar.gz;
    sha256 = "0sh2kz90z47yfa9786dyn3q9ba1xcmjvd65rykvm7mg5apnrg27h";
  };

  phases = "unpackPhase installPhase";
  installPhase = ''
    python ./setup.py install --prefix=$out
    sed -i $out/bin/rdiff-backup -e \
      "/import sys/ asys.path += [ \"$out/lib/python2.4/site-packages/\" ]"
  '';

  buildInputs = [python librsync gnused ];

  meta = {
    description = "backup system trying to combine best a mirror and an incremental backup system";
    homepage = http://rdiff-backup.nongnu.org/;
    license = "GPL-2";
  };
}
