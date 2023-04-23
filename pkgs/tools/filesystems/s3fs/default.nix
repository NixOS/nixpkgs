{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, curl, openssl, libxml2, fuse }:

stdenv.mkDerivation rec {
  pname = "s3fs-fuse";
  version = "1.91";

  src = fetchFromGitHub {
    owner  = "s3fs-fuse";
    repo   = "s3fs-fuse";
    rev    = "v${version}";
    sha256 = "sha256-41IgUgpVZiIzi3N5kgX7PAhgnd+i/FH1o8t5y3Uw14g=";
  };

  buildInputs = [ curl openssl libxml2 fuse ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  configureFlags = [
    "--with-openssl"
  ];

  postInstall = ''
    ln -s $out/bin/s3fs $out/bin/mount.s3fs
  '';

  meta = with lib; {
    description = "Mount an S3 bucket as filesystem through FUSE";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
