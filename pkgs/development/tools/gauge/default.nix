{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.9";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-YjLBfQ6L3UwcgQ9LgUfnNSegNhQI8/Gb5Hdpe0/uzOc=";
  };

  vendorHash = "sha256-Uir/umJNnTHWEKPbVch0Pq7B3hVim8BMtGc/M9esADw=";

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
