{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.8.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "getsops";
    repo = pname;
    sha256 = "sha256-nUeygUZdtDyYGW3hZdxBHSUxYILJcHoIIYRpoxkAlI4=";
  };

  vendorHash = "sha256-/fh6pQ7u1icIYGM4gJHXyDNQlAbLnVluw5icovBMZ5k=";

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/getsops/sops";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/raw/v${version}/CHANGELOG.rst";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
