{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, trezor-udev-rules
, AppKit
}:

buildGoModule rec {
  pname = "trezord-go";
  version = "2.0.33";
  commit = "2680d5e";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "trezord-go";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-3I6NOzDMhzRyVSOURl7TjJ1Z0P0RcKrSs5rNaZ0Ho9M=";
  };

  vendorHash = "sha256-wXgAmZEXdM4FcMCQbAs+ydXshCAMu7nl/yVv/3sqaXE=";

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
  };
}
