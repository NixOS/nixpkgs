{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezord-go-${version}";
  version = "2.0.12";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "03pz223jjfbd0g9gkk21q6d27jc8vd1bc1jz00i0f3dzvsyfx5g6";
  };

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = https://mytrezor.com;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ canndrew jb55 ];
    platforms = platforms.linux;
  };
}
