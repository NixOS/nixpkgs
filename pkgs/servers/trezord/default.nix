{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezord-go-${version}";
  version = "2.0.24";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "1fl2d57qqrrwl995w4b2d57rvl2cxxy6afjmcp648hhb3dnmp7c3";
  };

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = https://trezor.io;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ canndrew jb55 maintainers."1000101"];
    platforms = platforms.linux;
  };
}
