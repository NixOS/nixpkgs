{ stdenv, buildGoPackage, fetchFromGitHub, trezor-udev-rules }:

buildGoPackage rec {
  pname = "trezord-go";
  version = "2.0.28";

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "02c1mvn01gcfls37sa0c7v2lwffg14x54np8z7d4hjzxxzwg4gpw";
  };

  propagatedBuildInputs = [ trezor-udev-rules ];

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = "https://trezor.io";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ canndrew jb55 prusnak mmahut maintainers."1000101" ];
    platforms = platforms.unix;
  };
}
