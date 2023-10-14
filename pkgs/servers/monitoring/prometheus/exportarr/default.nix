{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exportarr";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    hash = "sha256-qe3i/sukAkE3DNiSc5BsY9OFWoAVuLsuYStlPfpVZQQ=";
  };

  vendorHash = "sha256-M+XDd2ubF4HLpFNPlhn++YXWwPwL6+5TMU+BDdkP+k0=";

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
