{ lib, buildGoModule, fetchFromGitHub, nixosTests, testers, dex-oidc }:

buildGoModule rec {
  pname = "dex";
  version = "2.40.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FaM8rBmfFmawtJRK0UmQNrRHebeFUg9ujXX8ubt4flw=";
  };

  vendorHash = "sha256-4YfuJPFYmIFKK1RqrdRy+LA8dXQbcB/qrBzzkQ60pXI=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w" "-s" "-X main.version=${src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/web $out/share/web
  '';

  passthru.tests = {
    inherit (nixosTests) dex-oidc;
    version = testers.testVersion {
      package = dex-oidc;
      command = "dex version";
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley techknowlogick ];
    mainProgram = "dex";
  };
}
