{ stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation rec {
  pname = "zerofree";
  version = "1.1.1";

  src = fetchurl {
    url = "https://frippery.org/uml/${pname}-${version}.tgz";
    sha256 = "0rrqfa5z103ws89vi8kfvbks1cfs74ix6n1wb6vs582vnmhwhswm";
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
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.theuni ];
  };
}
