{ stdenv, buildGoPackage, fetchFromGitHub, trezor-udev-rules }:

buildGoPackage rec {
  pname = "trezord-go";
  version = "2.0.29";

  goPackagePath = "github.com/trezor/trezord-go";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "1ks1fa0027s3xp0z6qp0dxmayvrb4dwwscfhbx7da0khp153f2cp";
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
