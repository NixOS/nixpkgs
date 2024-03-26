{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exportarr";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    hash = "sha256-hUgi50BFmtJfp/rNUA8QGYSflfSMANbelPndL7zV7v8=";
  };

  vendorHash = "sha256-Hy8OXFmGTxNlwbRjH05npD2p3avQfWk9k29R5sFKlNI=";

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
    mainProgram = "exportarr";
    homepage = "https://github.com/onedr0p/exportarr";
    changelog = "https://github.com/onedr0p/exportarr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
