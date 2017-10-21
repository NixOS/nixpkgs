{stdenv, fetchurl, python2Packages, librsync, gnused }:

python2Packages.buildPythonApplication {
  name = "rdiff-backup-1.3.3";

  src = fetchurl {
    url = mirror://savannah/rdiff-backup/rdiff-backup-1.3.3.tar.gz;
    sha256 = "01hcwf5rgqi303fa4kdjkbpa7n8mvvh7h9gpgh2b23nz73k0q0zf";
  };

  patches = [ ./fix-librsync-rs_default_strong_len.patch ];

  buildInputs = [ librsync gnused ];

  doCheck = false;

  meta = {
    description = "Backup system trying to combine best a mirror and an incremental backup system";
    homepage = http://rdiff-backup.nongnu.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
