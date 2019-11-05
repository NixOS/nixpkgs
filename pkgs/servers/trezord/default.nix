{ stdenv, buildGoPackage, fetchFromGitHub, trezor-udev-rules }:

buildGoPackage rec {
  pname = "trezord-go";
  version = "2.0.27";

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "00d90qmmk1pays78a2jm8gb7dncvlsjjn4033q1yd1ii3fxc6nh8";
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
