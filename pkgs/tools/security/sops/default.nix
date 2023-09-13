{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.7.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mozilla";
    repo = pname;
    sha256 = "sha256-wN1ksLwD4G+fUhvCe+jahh1PojPk6L6tnx1rsc7dz+M=";
  };

  vendorHash = "sha256-8IaE+vhVZkc9QDR6+/3eOSsuf3SYF2upNcCifbqtx14=";

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    changelog = "https://github.com/mozilla/sops/raw/v${version}/CHANGELOG.rst";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
