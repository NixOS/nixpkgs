{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezord-go-${version}";
  version = "2.0.25";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "151szgfbikijpwqrvqj43kw38kbbgx2g1khlbj6l4925qba7fycd";
  };

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = https://trezor.io;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ canndrew jb55 maintainers."1000101"];
    platforms = platforms.unix;
  };
}
