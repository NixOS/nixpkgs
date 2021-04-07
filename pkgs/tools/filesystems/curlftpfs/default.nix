{lib, stdenv, fetchurl, fuse, curl, pkg-config, glib, zlib}:

stdenv.mkDerivation {
  name = "curlftpfs-0.9.2";
  src = fetchurl {
    url = "mirror://sourceforge/curlftpfs/curlftpfs-0.9.2.tar.gz";
    sha256 = "0n397hmv21jsr1j7zx3m21i7ryscdhkdsyqpvvns12q7qwwlgd2f";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [fuse curl glib zlib];

  doCheck = false; # fails, doesn't work well too, btw

  meta = with lib; {
    description = "Filesystem for accessing FTP hosts based on FUSE and libcurl";
    homepage = "http://curlftpfs.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.linux;

  };
}
