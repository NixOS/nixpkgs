{stdenv, fetchurl, autoconf, automake, pkgconfig, curl, openssl, libxml2, fuse}:

stdenv.mkDerivation {
  name = "s3fs-fuse-1.80";

  src = fetchurl {
    url = https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.80.tar.gz;
    sha256 = "0ddx5khlyyrxm4s8is4gqbczmrcivj11hmkk9s893r3kpp4q30yy";
  };

  preConfigure = "./autogen.sh";
  buildInputs = [ autoconf automake pkgconfig curl openssl libxml2 fuse ];

  postInstall = ''
    ln -s $out/bin/s3fs $out/bin/mount.s3fs
  '';

  meta = with stdenv.lib; {
    description = "Mount an S3 bucket as filesystem through FUSE";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
