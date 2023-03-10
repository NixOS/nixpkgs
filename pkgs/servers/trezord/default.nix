{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, trezor-udev-rules
, AppKit
}:

buildGoModule rec {
  pname = "trezord-go";
  version = "2.0.32";
  commit = "9aa6576";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "trezord-go";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-T7YoHi2sA22nfNbgX2WB5NIFIwxBkxn0CsSXyQTxgJc=";
  };

  vendorSha256 = "sha256-wXgAmZEXdM4FcMCQbAs+ydXshCAMu7nl/yVv/3sqaXE=";

  propagatedBuildInputs = lib.optionals stdenv.isLinux [ trezor-udev-rules ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ];

  ldflags = [
    "-s" "-w"
    "-X main.githash=${commit}"
  ];

  meta = with lib; {
    description = "Trezor Communication Daemon aka Trezor Bridge";
    homepage = "https://trezor.io";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ canndrew jb55 prusnak mmahut _1000101 ];
    mainProgram = "trezord-go";
    platforms = platforms.unix;
  };
}
