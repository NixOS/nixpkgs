{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "infra";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "infrahq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-luwswGFI+ygLWp8Yi0PuZpkjQiPiF7bCv0kc8DNYxkw=";
  };

  vendorSha256 = "sha256-j+ZtBqAIeI25qRKu6RvW79Ug/lUGreC06qXL5dgchHc=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Infra manages access to infrastructure such as Kubernetes";
    homepage = "https://github.com/infrahq/infra";
    changelog = "https://github.com/infrahq/infra/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
