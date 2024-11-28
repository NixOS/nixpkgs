{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
, trezor-udev-rules
, nixosTests
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
    hash = "sha256-3I6NOzDMhzRyVSOURl7TjJ1Z0P0RcKrSs5rNaZ0Ho9M=";
  };

  vendorHash = "sha256-wXgAmZEXdM4FcMCQbAs+ydXshCAMu7nl/yVv/3sqaXE=";

  patches = [
    (fetchpatch {
      url = "https://github.com/trezor/trezord-go/commit/616473d53a8ae49f1099e36ab05a2981a08fa606.patch";
      hash = "sha256-yKTwgqWr4L6XEPV85A6D1wpRdpef8hkIbl4LrRmOyuo=";
    })
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ trezor-udev-rules ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ AppKit ];

  ldflags = [
    "-s" "-w"
    "-X main.githash=${commit}"
  ];

  passthru.tests = { inherit (nixosTests) trezord; };

  meta = with lib; {
    description = "Trezor Communication Daemon aka Trezor Bridge";
    homepage = "https://trezor.io";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ canndrew jb55 prusnak mmahut _1000101 ];
    mainProgram = "trezord-go";
  };
}
