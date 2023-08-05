{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, curl, openssl, libxml2, fuse }:

stdenv.mkDerivation rec {
  pname = "s3fs-fuse";
  version = "1.93";

  src = fetchFromGitHub {
    owner  = "s3fs-fuse";
    repo   = "s3fs-fuse";
    rev    = "v${version}";
    sha256 = "sha256-7rLHnQlyJDOn/RikOrrEAQ7O+4T+26vNGiTkOgNH75Q=";
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
    homepage = "https://github.com/s3fs-fuse/s3fs-fuse";
    changelog = "https://github.com/s3fs-fuse/s3fs-fuse/raw/v${version}/ChangeLog";
    maintainers = [ ];
    license = licenses.gpl2Only;
    platforms = platforms.unix;
  };
}
