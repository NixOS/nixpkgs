{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.11";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-4Fjh2wVl5k01YH1bNW8tAn6J44cWvwUnBqu2dE63wKY=";
  };

  vendorHash = "sha256-xxWcniT9aaLw3rX7uHTRmIVw4BVR1MDIpvF21pfMtDk=";

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
