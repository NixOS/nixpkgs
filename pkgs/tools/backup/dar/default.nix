{ stdenv, fetchurl
, attr, e2fsprogs
, curl, librsync, libthreadar
, gpgme, libgcrypt, openssl
, bzip2, lzo, xz, zlib
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.6.12";
  pname = "dar";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${pname}-${version}.tar.gz";
    sha256 = "0jwgaim2p93skdpjwiz5qgibd3j9965ycqn47wrrjlcvzk93mvyk";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    curl librsync libthreadar
    gpgme libgcrypt openssl
    bzip2 lzo xz zlib
  ] ++ optionals stdenv.isLinux [ attr e2fsprogs ];

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
