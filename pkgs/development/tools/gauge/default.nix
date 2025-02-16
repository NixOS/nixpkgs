{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.13";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-oyZDz3SX68rlnAG+JzKeIKyKUjQ+ttTrzthHUwW0b54=";
  };

  vendorHash = "sha256-nqyzNbD2j6b34QpFiv2yVxEVkrZkuzcwAt9uqAB2iA4=";

  excludedPackages = [
    "build"
    "man"
  ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      vdemeester
      marie
    ];
  };
}
