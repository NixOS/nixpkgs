{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-LqgA990os33Hftu8+h/HKnOcGcKsAXVuQl1hmCmA5n4=";
  };

  vendorHash = "sha256-zY6c9Wnq00cAuw0WIK3XsTZ1/YL8lnzSEnusUY5VsxY=";

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) consul-template;
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud pradeepchhetri ];
  };
}
