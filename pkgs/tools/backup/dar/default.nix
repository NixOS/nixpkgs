{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs, gpgme, xz }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.6.0";
  name = "dar-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "0avaffkfrgj8vhvnpqi4s21bsrlxl0xafpyd3v9n3f9hs2gnm3wg";
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
