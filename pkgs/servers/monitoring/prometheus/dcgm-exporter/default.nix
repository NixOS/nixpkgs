{ lib
, buildGoModule
, fetchFromGitHub
, cudaPackages
, dcgm
, linuxPackages
}:
buildGoModule rec {
  pname = "dcgm-exporter";

  # The first portion of this version string corresponds to a compatible DCGM
  # version.
  version = "3.2.5-3.1.7"; # N.B: If you change this, update dcgm as well to the matching version.

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+Hviq+iu1LBcy2VwmCX5xOq1I/zevfydesVlrVorGOI=";
  };

  # Upgrade to go 1.17 during the vendoring FOD build because it fails otherwise.
  overrideModAttrs = _: {
    preBuild = ''
      substituteInPlace go.mod --replace 'go 1.16' 'go 1.17'
      go mod tidy
    '';
    postInstall = ''
      cp go.mod "$out/go.mod"
    '';
  };

  CGO_LDFLAGS = "-ldcgm";

  buildInputs = [
    dcgm
  ];

  # gonvml and go-dcgm do not work with ELF BIND_NOW hardening because not all
  # symbols are available on startup.
  hardeningDisable = [ "bindnow" ];

  # Copy the modified go.mod we got from the vendoring process.
  preBuild = ''
    cp vendor/go.mod go.mod
  '';

  vendorHash = "sha256-Fjvx15e/psxoqoS6c6GhiQfe7g2aI40EmPR26xLhrzg=";

  nativeBuildInputs = [
    cudaPackages.autoAddDriverRunpath
  ];

  # Tests try to interact with running DCGM service.
  doCheck = false;

  postFixup = ''
    patchelf --add-needed libnvidia-ml.so "$out/bin/dcgm-exporter"
  '';

  meta = with lib; {
    description = "NVIDIA GPU metrics exporter for Prometheus leveraging DCGM";
    homepage = "https://github.com/NVIDIA/dcgm-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
    mainProgram = "dcgm-exporter";
    platforms = platforms.linux;
  };
}
