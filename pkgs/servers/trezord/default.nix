{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezord-go-${version}";
  version = "2.0.19";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "19am5zs2mx36w2f8b5001i1sg6v72y1nq5cagnw6rza8qxyw83qs";
  };

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = https://trezor.io;
    license = licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ canndrew jb55 1000101];
    platforms = platforms.linux;
  };
}
