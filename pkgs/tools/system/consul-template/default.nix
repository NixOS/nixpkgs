{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    sha256 = "sha256-HxzniR4z3YzvFww3KqhtelaqMQJBsSw83pfz+jHxvKQ=";
  };

  vendorSha256 = "sha256-wRNfxJVX45dfIBZ0sy48qbPkAsD0CIB1PDTiGs8Fjhs=";

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud pradeepchhetri ];
  };
}
