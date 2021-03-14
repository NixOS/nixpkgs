{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, curl, openssl, libxml2, fuse, osxfuse }:

stdenv.mkDerivation rec {
  pname = "s3fs-fuse";
  version = "1.89";

  src = fetchFromGitHub {
    owner  = "s3fs-fuse";
    repo   = "s3fs-fuse";
    rev    = "v${version}";
    sha256 = "sha256-Agb0tq7B98Ioe0G/XEZCYcFQKnMuYXX9x0yg4Gvu3/k=";
  };

  buildInputs = [ curl openssl libxml2 ]
    ++ lib.optionals stdenv.isLinux [ fuse ]
    ++ lib.optionals stdenv.isDarwin [ osxfuse ];
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
