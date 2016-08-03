{stdenv, fetchurl, autoconf, automake, pkgconfig, curl, openssl, libxml2, fuse}:

stdenv.mkDerivation {
  name = "s3fs-fuse-1.79";
  src = fetchurl {
    url = https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz;
    sha256 = "0rmzkngzq040g020pv75qqx3jy34vdxzqvxz29k6q8yfb3wpkhb1";
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
