{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs, gpgme, xz }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.6.7";
  pname = "dar";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${pname}-${version}.tar.gz";
    sha256 = "055kkxhg7sz3fbndsr4p2wp7aa2phq3pr0a9y7b1fkg52x7fbhr2";
  };

  buildInputs = [ zlib bzip2 openssl lzo libgcrypt gpgme xz ]
    ++ optionals stdenv.isLinux [ attr e2fsprogs ];

  configureFlags = [
    "--disable-birthtime"
    "--disable-upx"
    "--disable-dar-static"
    "--disable-build-html"
    "--enable-threadar"
  ];

  postInstall = ''
    rm -r "$out"/share/dar # Disable html help
  '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://dar.linux.free.fr;
    description = "Disk ARchiver, allows backing up files into indexed archives";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
