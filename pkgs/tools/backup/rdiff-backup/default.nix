{stdenv, fetchurl, python, librsync, gnused }:

stdenv.mkDerivation {
  name = "rdiff-backup-1.3.3";

  src = fetchurl {
    url = mirror://savannah/rdiff-backup/rdiff-backup-1.3.3.tar.gz;
    sha256 = "01hcwf5rgqi303fa4kdjkbpa7n8mvvh7h9gpgh2b23nz73k0q0zf";
  };

  phases = "unpackPhase installPhase";
  installPhase = ''
    python ./setup.py install --prefix=$out
    sed -i $out/bin/rdiff-backup -e \
      "/import sys/ asys.path += [ \"$out/lib/python2.7/site-packages/\" ]"
  '';

  buildInputs = [ python librsync gnused ];

  meta = {
    description = "backup system trying to combine best a mirror and an incremental backup system";
    homepage = http://rdiff-backup.nongnu.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
