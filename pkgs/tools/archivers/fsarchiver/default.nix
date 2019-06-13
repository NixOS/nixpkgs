{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, zlib, bzip2, lzma, lzo, lz4, zstd, xz
, libgcrypt, e2fsprogs, utillinux, libgpgerror }:

let
  version = "0.8.5";

in stdenv.mkDerivation {
  name = "fsarchiver-${version}";

  src = fetchFromGitHub {
    owner = "fdupoux";
    repo = "fsarchiver";
    rev = version;
    sha256 = "1rvwq5v3rl14bqxjm1ibfapyicf0sa44nw7451v10kx39lp56ylp";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig
  ];

  buildInputs = [
    zlib bzip2 lzma lzo lz4 zstd xz
    libgcrypt e2fsprogs utillinux libgpgerror
  ];

  meta = with stdenv.lib; {
    description = "File system archiver for linux";
    longDescription = ''
      FSArchiver is a system tool that allows you to save the contents of a
      file-system to a compressed archive file. The file-system can be restored
      on a partition which has a different size and it can be restored on a
      different file-system. Unlike tar/dar, FSArchiver also creates the
      file-system when it extracts the data to partitions. Everything is
      checksummed in the archive in order to protect the data. If the archive is
      corrupt, you just loose the current file, not the whole archive.
    '';
    homepage = http://www.fsarchiver.org/;
    license = licenses.lgpl2;
    maintainers = [ maintainers.etu ];
    platforms = platforms.linux;
  };
}
