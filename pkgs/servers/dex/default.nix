{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  testers,
  dex-oidc,
}:

buildGoModule rec {
  pname = "dex";
  version = "2.39.1";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+P3KYowZmtgZP3i0D+GFaAqgWDqJ8sxI4LyDUOM+J38=";
  };

  vendorHash = "sha256-NQXsptpRNgRuEeh2ft/dbqcZqO/d1KZ19wc/7To0xCM=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${src.rev}"
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
    maintainers = with maintainers; [
      benley
      techknowlogick
    ];
    mainProgram = "dex";
  };
}
