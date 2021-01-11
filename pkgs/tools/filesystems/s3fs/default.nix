{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, curl, openssl, libxml2, fuse, osxfuse }:

stdenv.mkDerivation rec {
  pname = "s3fs-fuse";
  version = "1.87";

  src = fetchFromGitHub {
    owner  = "s3fs-fuse";
    repo   = "s3fs-fuse";
    rev    = "v${version}";
    sha256 = "09ib3sh6vg3z7cpccj3ysgpdyf84a98lf6nz15a61r4l27h111f2";
  };

  buildInputs = [ curl openssl libxml2 ]
    ++ stdenv.lib.optionals stdenv.isLinux [ fuse ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ osxfuse ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

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
