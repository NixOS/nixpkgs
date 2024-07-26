{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-s1UhbCxqWm7a5ulPPnbw0lO5lbRShTBBzAGuxWV5msM=";
  };

  vendorHash = "sha256-eFxXiRO2ruf1YLLWsCAYxTNUnKpaBXO8mLM4REThG1s=";

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
