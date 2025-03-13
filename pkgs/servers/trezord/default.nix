{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  trezor-udev-rules,
  nixosTests,
  AppKit,
}:

buildGoModule rec {
  pname = "trezord-go";
  version = "2.0.33-unstable-2024-01-04";
  commit = "db03d99";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "trezord-go";
    rev = "db03d99230f5b609a354e3586f1dfc0ad6da16f7";
    fetchSubmodules = true;
    hash = "sha256-PomM8k4vAp+aCsJyPZhCZM9gPOJbTZ5kr7YPKzvqZ/w=";
  };

  vendorHash = "sha256-wXgAmZEXdM4FcMCQbAs+ydXshCAMu7nl/yVv/3sqaXE=";

  patches = [
    (fetchpatch {
      url = "https://github.com/trezor/trezord-go/commit/b1161ab907a2416a58ac3a39fb525c12ac808a1f.patch";
      hash = "sha256-jW+x/FBFEIlRGTDHWF2Oj+05KmFLtFDGJwfYFx7yTv4=";
    })
  ];

  propagatedBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ trezor-udev-rules ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ AppKit ];

  ldflags = [
    "-s"
    "-w"
    "-X main.githash=${commit}"
  ];

  passthru.tests = { inherit (nixosTests) trezord; };

  meta = with lib; {
    description = "Trezor Communication Daemon aka Trezor Bridge";
    homepage = "https://trezor.io";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      canndrew
      jb55
      prusnak
      mmahut
      _1000101
    ];
    mainProgram = "trezord-go";
  };
}
