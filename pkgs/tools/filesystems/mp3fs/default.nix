{ lib, stdenv, fetchurl, flac, fuse, lame, libid3tag, pkg-config }:

stdenv.mkDerivation rec {
  pname = "mp3fs";
  version = "0.91";

  src = fetchurl {
    url = "https://github.com/khenriks/mp3fs/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "14ngiqg24p3a0s6hp33zjl4i46d8qn4v9id36psycq3n3csmwyx4";
  };

  patches = [ ./fix-statfs-operation.patch ];

  buildInputs = [ flac fuse lame libid3tag ];
  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "FUSE file system that transparently transcodes to MP3";
    longDescription = ''
      A read-only FUSE filesystem which transcodes between audio formats
      (currently only FLAC to MP3) on the fly when files are opened and read.
      It can let you use a FLAC collection with software and/or hardware
      which only understands the MP3 format, or transcode files through
      simple drag-and-drop in a file browser.
    '';
    homepage = "https://khenriks.github.io/mp3fs/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
