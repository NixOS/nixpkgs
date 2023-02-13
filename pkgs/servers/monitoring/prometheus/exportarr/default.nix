{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exportarr";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    sha256 = "sha256-KTuOhyBFS6fgA9N70vq+5fJIGVsgEZ7Uxls8efqLuII=";
  };

  vendorSha256 = "sha256-Yox3LAVbTZqsDmk45uSuKgITRz3zE+HTAKxVf9wdtjE=";

  subPackages = [ "cmd/exportarr" ];

  CGO_ENABLE = 0;

  ldflags = [ "-s" "-w" ];

  tags = lib.optionals stdenv.isLinux [ "netgo" ];

  # There are no tests for this package.
  doCheck = false;

  meta = with lib; {
    description = "AIO Prometheus Exporter for Sonarr, Radarr or Lidarr";
    homepage = "https://github.com/onedr0p/exportarr";
    changelog = "https://github.com/onedr0p/exportarr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
