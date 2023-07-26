{ lib
, buildGoModule
, fetchFromGitHub
, cudaPackages
, dcgm
, linuxPackages
}:
buildGoModule rec {
  pname = "dcgm-exporter";
  version = "3.1.8-3.1.5";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Jzv3cU3gmGIXV+DV3wV/1zSWwz18s3Jax6JC7WZW7Z4=";
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

  vendorHash = "sha256-KMCV79kUY1sNYysH0MmB7pVU98r7v+DpLIoYHxyyG4U=";

  nativeBuildInputs = [
    cudaPackages.autoAddOpenGLRunpathHook
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
