{
  lib,
  stdenv,
  fetchzip,
  which,
  attr,
  e2fsprogs,
  curl,
  libargon2,
  librsync,
  libthreadar,
  gpgme,
  libgcrypt,
  openssl,
  bzip2,
  lz4,
  lzo,
  xz,
  zlib,
  zstd,
  CoreFoundation,
}:

stdenv.mkDerivation rec {
  version = "2.7.13";
  pname = "dar";

  src = fetchzip {
    url = "mirror://sourceforge/dar/${pname}-${version}.tar.gz";
    sha256 = "sha256-d88BwbovhbAn72y5pVd4No+hVydXbtZYHZpdtpo4RGY=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ which ];

  buildInputs = [
    curl
    librsync
    libthreadar
    gpgme
    libargon2
    libgcrypt
    openssl
    bzip2
    lz4
    lzo
    xz
    zlib
    zstd
  ] ++ lib.optionals stdenv.isLinux [
    attr
    e2fsprogs
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
  ];

  configureFlags = [
    "--disable-birthtime"
    "--disable-upx"
    "--disable-dar-static"
    "--disable-build-html"
    "--enable-threadar"
  ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  postInstall = ''
    # Disable html help
    rm -r "$out"/share/dar
  '';

  meta = with lib; {
    homepage = "http://dar.linux.free.fr";
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = with maintainers; [ izorkin ];
    license = licenses.gpl2Only;
    platforms = platforms.unix;
  };
}
