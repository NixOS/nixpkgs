{ stdenv
, buildGoModule
, fetchFromGitHub
, trezor-udev-rules
}:

buildGoModule rec {
  pname = "trezord-go";
  version = "2.0.30";

  src = fetchFromGitHub {
    owner  = "trezor";
    repo   = "trezord-go";
    rev    = "v${version}";
    sha256 = "1hzvk0wfgg7b4wpqjk3738yqxlv3pj5i7zxwm0jady2h97hmrqrr";
  };

  vendorSha256 = "0wb959xzyvr5zzjvkfqc422frmf97q5nr460f02wwx0pj6ch0y61";

  propagatedBuildInputs = [ trezor-udev-rules ];

  meta = with stdenv.lib; {
    description = "TREZOR Communication Daemon aka TREZOR Bridge";
    homepage = "https://trezor.io";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ canndrew jb55 prusnak mmahut _1000101 ];
    platforms = platforms.unix;
  };
}
