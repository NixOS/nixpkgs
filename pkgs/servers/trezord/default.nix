{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezord-go-${version}";
  version = "2.0.26";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "0z6x3rf0wm1d7ws1n3m0vq8jmjjki2r9qrq4hkdq4nv61mw4ivyc";
  };

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = https://trezor.io;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ canndrew jb55 "1000101" prusnak ];
    platforms = platforms.unix;
  };
}
