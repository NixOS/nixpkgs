{ lib
, stdenv
, fetchFromGitHub
, zlib
, xz
, lz4
, lzo
, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs";
  version = "4.5";

  src = fetchFromGitHub {
    owner = "plougher";
    repo = "squashfs-tools";
    rev = version;
    sha256 = "1nanwz5qvsakxfm37md5i7xqagv69nfik9hpj8qlp6ymw266vgxr";
  };

  patches = [
    # This patch adds an option to pad filesystems (increasing size) in
    # exchange for better chunking / binary diff calculation.
    ./4k-align.patch
  ] ++ lib.optional stdenv.isDarwin ./darwin.patch;

  buildInputs = [ zlib xz zstd lz4 lzo ];

  preBuild = ''
    cd squashfs-tools
  '' ;

  installFlags = [ "INSTALL_DIR=${placeholder "out"}/bin" ];

  makeFlags = [
    "XZ_SUPPORT=1"
    "ZSTD_SUPPORT=1"
    "LZ4_SUPPORT=1"
    "LZO_SUPPORT=1"
  ];

  meta = with lib; {
    homepage = "https://github.com/plougher/squashfs-tools";
    description = "Tool for creating and unpacking squashfs filesystems";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ruuda ];
  };
}
