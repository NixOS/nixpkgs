{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, curl, openssl, libxml2, fuse }:

stdenv.mkDerivation rec {
  name = "s3fs-fuse-${version}";
  version = "1.84";

  src = fetchFromGitHub {
    owner  = "s3fs-fuse";
    repo   = "s3fs-fuse";
    rev    = "v${version}";
    sha256 = "1iafzlrqrjyphd1p74q5xzhgacc4gzijq8f6mdkvikbdsibch871";
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
