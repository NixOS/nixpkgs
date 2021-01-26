{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, curl, openssl, libxml2, fuse, osxfuse }:

stdenv.mkDerivation rec {
  pname = "s3fs-fuse";
  version = "1.88";

  src = fetchFromGitHub {
    owner  = "s3fs-fuse";
    repo   = "s3fs-fuse";
    rev    = "v${version}";
    sha256 = "sha256-LxqTKu9F8FqHnjp1a9E/+WbH1Ol6if/OpY7LGsVE9Bw=";
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
