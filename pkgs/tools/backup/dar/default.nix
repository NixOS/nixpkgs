args @ {
  lib,
  stdenv,
  llvmPackages_12, # Anything newer than 11
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
  CoreFoundation,
}:

let
  # Fails to build with clang-11 on Darwin:
  # error: exception specification of overriding function is more lax than base version
  stdenv = if args.stdenv.isDarwin then llvmPackages_12.stdenv else args.stdenv;
in

stdenv.mkDerivation rec {
  version = "2.7.8";
  pname = "dar";

  src = fetchzip {
    url = "mirror://sourceforge/dar/${pname}-${version}.tar.gz";
    sha256 = "sha256-W/6kSkIaeHumE2yGGbU4Z2lk1d2toQ1AM012TUI1EZw=";
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
