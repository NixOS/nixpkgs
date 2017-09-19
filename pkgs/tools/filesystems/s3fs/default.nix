{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, curl, openssl, libxml2, fuse }:

stdenv.mkDerivation rec {
  name = "s3fs-fuse-${version}";
  version = "1.82";

  src = fetchFromGitHub {
    owner  = "s3fs-fuse";
    repo   = "s3fs-fuse";
    rev    = "v${version}";
    sha256 = "0bammbb8h10n51qk5141gabsd5p91qbaqq7cwa1q8yf5qglwlp10";
  };

  buildInputs = [ curl openssl libxml2 fuse ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags = [
    "--with-openssl"
  ];

  postInstall = ''
    ln -s $out/bin/s3fs $out/bin/mount.s3fs
  '';

  meta = with stdenv.lib; {
    description = "Mount an S3 bucket as filesystem through FUSE";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
