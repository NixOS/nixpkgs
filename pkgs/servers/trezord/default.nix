{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezord-go-${version}";
  version = "2.0.14";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "1bnzib1cbs7cj6vdf015vr60vm5wgfgbqajcpqxcikfckwhjsykv";
  };

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = https://mytrezor.com;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ canndrew jb55 ];
    platforms = platforms.linux;
  };
}
