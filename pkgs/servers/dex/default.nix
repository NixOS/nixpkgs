{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "dex";
  version = "2.35.3";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sYEdlEEpO0JDPHuGC457IPUcpp5PO2BLX/Gvd/vJvWQ=";
  };

  vendorSha256 = "sha256-2rg99+Zv+Lj6udhld0BwFrpVsyGC0IfX5Xqc7dRN13o=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w" "-s" "-X github.com/dexidp/dex/version.Version=${src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/web $out/share/web
  '';

  passthru.tests = { inherit (nixosTests) dex-oidc; };

  meta = with lib; {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley techknowlogick ];
    platforms = platforms.unix;
  };
}
