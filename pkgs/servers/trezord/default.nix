{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, trezor-udev-rules
, AppKit
}:

buildGoModule rec {
  pname = "trezord-go";
  version = "2.0.31";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "trezord-go";
    rev = "v${version}";
    sha256 = "130nhk1pnr3xx9qkcij81mm3jxrl5zvvdqhvrgvrikqg3zlb6v5b";
  };

  vendorSha256 = "0wb959xzyvr5zzjvkfqc422frmf97q5nr460f02wwx0pj6ch0y61";

  propagatedBuildInputs = lib.optionals stdenv.isLinux [ trezor-udev-rules ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "Trezor Communication Daemon aka Trezor Bridge";
    homepage = "https://trezor.io";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ canndrew jb55 prusnak mmahut _1000101 ];
    mainProgram = "trezord-go";
    platforms = platforms.unix;
  };
}
