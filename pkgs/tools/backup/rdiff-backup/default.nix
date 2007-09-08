args:
args.stdenv.mkDerivation {
  name = "rdiff-backup-1.1.14";

  src = args.fetchurl {
    url = http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.1.14.tar.gz;
    sha256 = "0sh2kz90z47yfa9786dyn3q9ba1xcmjvd65rykvm7mg5apnrg27h";
  };

  phases="installPhase";
  installPhase="python setup.py install --prefix=\$out || fail
  sed -i \$out/bin/rdiff-backup -e \\
    \"/import sys/ asys.path += [ \\\"\$out/lib/python2.4/site-packages/\\\" ]\"
    
  ";

  buildInputs = (with args; [python librsync gnused ]);

  meta = {
      description = "backup system trying to combine best a mirror and an incremental backup system";
      homepage = http://rdiff-backup.nongnu.org/;
      license = "GPL-2";
    };
}
