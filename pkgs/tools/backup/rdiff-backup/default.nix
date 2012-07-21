{stdenv, fetchurl, python, librsync, gnused }:

stdenv.mkDerivation {
  name = "rdiff-backup-1.2.8";

  src = fetchurl {
    url = http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz;
    sha256 = "1nwmmh816f96h0ff1jxk95ad38ilbhbdl5dgibx1d4cl81dsi48d";
  };

  phases = "unpackPhase installPhase";
  installPhase = ''
    python ./setup.py install --prefix=$out
    sed -i $out/bin/rdiff-backup -e \
      "/import sys/ asys.path += [ \"$out/lib/python2.7/site-packages/\" ]"
  '';

  buildInputs = [python librsync gnused ];

  meta = {
    description = "backup system trying to combine best a mirror and an incremental backup system";
    homepage = http://rdiff-backup.nongnu.org/;
    license = "GPL-2";
  };
}
