{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, zlib, bzip2, lzo, lz4, zstd, xz
, libgcrypt, e2fsprogs, util-linux, libgpg-error }:

let
  version = "0.8.7";

in stdenv.mkDerivation {
  pname = "fsarchiver";
  inherit version;

  src = fetchFromGitHub {
    owner = "fdupoux";
    repo = "fsarchiver";
    rev = version;
    sha256 = "sha256-1ZIqFgB05gV1L7P/AIL4qfYT4cNMp75QElEM64BXyO8=";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config
  ];

  buildInputs = [
    zlib bzip2 xz lzo lz4 zstd xz
    libgcrypt e2fsprogs util-linux libgpg-error
  ];

  meta = with lib; {
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
    homepage = "https://www.fsarchiver.org/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
