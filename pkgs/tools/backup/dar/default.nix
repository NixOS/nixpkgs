{ lib, gccStdenv, fetchurl
, which
, attr, e2fsprogs
, curl, libargon2, librsync, libthreadar
, gpgme, libgcrypt, openssl
, bzip2, lz4, lzo, xz, zlib
, CoreFoundation
}:

with lib;

let
  # Fails to build with clang on Darwin:
  # error: exception specification of overriding function is more lax than base version
  stdenv = gccStdenv;
in

stdenv.mkDerivation rec {
  version = "2.7.7";
  pname = "dar";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${pname}-${version}.tar.gz";
    sha256 = "sha256-wD4vUu/WWi8Ee2C77aJGDLUlFl4b4y8RC2Dgzs4/LMk=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ which ];

  buildInputs = [
    curl librsync libthreadar
    gpgme libargon2 libgcrypt openssl
    bzip2 lz4 lzo xz zlib
  ] ++ optionals stdenv.isLinux [
    attr
    e2fsprogs
  ] ++ optionals stdenv.isDarwin [
    CoreFoundation
  ];

  configureFlags = [
    "--disable-birthtime"
    "--disable-upx"
    "--disable-dar-static"
    "--disable-build-html"
    "--enable-threadar"
  ];

  postInstall = ''
    # Disable html help
    rm -r "$out"/share/dar
  '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://dar.linux.free.fr";
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = with maintainers; [ izorkin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
