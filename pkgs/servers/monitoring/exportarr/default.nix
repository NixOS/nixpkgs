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
    hash = "sha256-KTuOhyBFS6fgA9N70vq+5fJIGVsgEZ7Uxls8efqLuII=";
  };

  vendorSha256 = "sha256-Yox3LAVbTZqsDmk45uSuKgITRz3zE+HTAKxVf9wdtjE=";

  subPackages = [ "cmd/exportarr" ];

  ldflags = [
    "-s"
    "-w"
  ] ++ lib.optionals stdenv.isLinux [
    "-extldflags=-static"
  ];

  tags = lib.optionals stdenv.isLinux [ "netgo" ];

  meta = with lib; {
    description = "AIO Prometheus Exporter for Sonarr, Radarr or Lidarr";
    homepage = "https://github.com/onedr0p/exportarr";
    changelog = "https://github.com/onedr0p/exportarr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
