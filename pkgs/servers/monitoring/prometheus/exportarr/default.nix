{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exportarr";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    hash = "sha256-i5ia9GX/0wvLnIwSxZ50y3fTFHwkUzj00+NoEceXp84=";
  };

  vendorHash = "sha256-2gzHX7XHzgvZXWm7mfakxnsRfpEysQwnZ0mJocLyyoA=";

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
