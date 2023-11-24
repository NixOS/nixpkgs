{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-/Tf4himhvX7RP+zCd4Dhgcrdo+19Unm2ypaZxGiAfrc=";
  };

  vendorHash = "sha256-I/prgTUk5FviC9STb7+Yq0VJ1BzlKpnK+Ko21ut1sP4=";

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
    mainProgram = "consul-template";
  };
}
