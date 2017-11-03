{ stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "zerofree-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://frippery.org/uml/${name}.tgz";
    sha256 = "059g29x5r1xj6wcj4xj85l8w6qrxyl86yqbybjqqz6nxz4falxzf";
  };

  buildInputs = [ e2fsprogs ];

  installPhase = ''
    mkdir -p $out/bin
    cp zerofree $out/bin
'';

  meta = {
    homepage = https://frippery.org/uml/;
    description = "Zero free blocks from ext2, ext3 and ext4 file-systems";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.theuni ];
  };
}
