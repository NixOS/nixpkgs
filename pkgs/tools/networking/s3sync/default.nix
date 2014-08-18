{ stdenv, fetchurl, ruby, makeWrapper }:

stdenv.mkDerivation {
  name = "s3sync-1.2.6";
  
  src = fetchurl {
    url = http://s3.amazonaws.com/ServEdge_pub/s3sync/s3sync.tar.gz; # !!!
    sha256 = "19467mgym0da0hifhkcbivccdima7gkaw3k8q760ilfbwgwxcn7f";
  };

  buildInputs = [ makeWrapper ];

  installPhase =
    ''
      mkdir -p $out/libexec/s3sync
      cp *.rb $out/libexec/s3sync
      makeWrapper "${ruby}/bin/ruby $out/libexec/s3sync/s3cmd.rb" $out/bin/s3cmd
      makeWrapper "${ruby}/bin/ruby $out/libexec/s3sync/s3sync.rb" $out/bin/s3sync

      mkdir -p $out/share/doc/s3sync
      cp README* $out/share/doc/s3sync/
    ''; # */

  meta = {
    homepage = http://s3sync.net/;
    description = "Command-line tools to manipulate Amazon S3 buckets";
    license = "free-non-copyleft";
  };
}
