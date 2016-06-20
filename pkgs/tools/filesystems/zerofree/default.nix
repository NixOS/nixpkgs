{ stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "zerofree-1.0.3";

  src = fetchurl {
    url = "http://intgat.tigress.co.uk/rmy/uml/zerofree-1.0.3.tgz";
    sha256 = "3acfda860be0f0ddcb5c982ff3b4475b1ee8cc35a90ae2a910e93261dbe0ccf6";
  };

  buildInputs = [ e2fsprogs ];

  installPhase = ''
    mkdir -p $out/bin
    cp zerofree $out/bin
'';

  meta = {
    homepage = http://intgat.tigress.co.uk/rmy/uml/index.html;
    description = "Zero free blocks from ext2, ext3 and ext4 file-systems";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.theuni ];
  };
}
