{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nUeygUZdtDyYGW3hZdxBHSUxYILJcHoIIYRpoxkAlI4=";
  };

  vendorHash = "sha256-/fh6pQ7u1icIYGM4gJHXyDNQlAbLnVluw5icovBMZ5k=";

  subPackages = [ "cmd/sops" ];

  ldflags = [ "-s" "-w" "-X github.com/getsops/sops/v3/version.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/getsops/sops";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${version}/CHANGELOG.rst";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
