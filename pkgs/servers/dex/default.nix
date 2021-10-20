{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "dex";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z/X9Db57eNUJdjzLCJNIW3lCRw05JP2TQ43PqKO6CiI=";
  };

  vendorSha256 = "sha256-ksN/1boBQVhevlDseVZsGUWL+Bwy4AMgGNdOPgsNNxk=";

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
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
