{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exportarr";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    hash = "sha256-7ev6twbavAhSZWJZCwjpbEz2STRYifLrPCFyel+Ml5A=";
  };

  vendorHash = "sha256-3JObDCeRjhws6U4DRky7BVEleCmxadLmPnTp8PX6S7A=";

  subPackages = [ "cmd/exportarr" ];

  CGO_ENABLE = 0;

  ldflags = [ "-s" "-w" ];

  tags = lib.optionals stdenv.isLinux [ "netgo" ];

  preCheck = ''
    # Run all tests.
    unset subPackages
  '';

  meta = with lib; {
    description = "AIO Prometheus Exporter for Sonarr, Radarr or Lidarr";
    homepage = "https://github.com/onedr0p/exportarr";
    changelog = "https://github.com/onedr0p/exportarr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
