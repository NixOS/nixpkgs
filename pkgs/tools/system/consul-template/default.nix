{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    sha256 = "sha256-Q2mNMgGnwyYXVsmP6cVVlGEs2fHUZKwrWepmmQXmNLo=";
  };

  vendorHash = "sha256-75IFVVd4L70kEV5L7Ub9RpR9LMhkz3fB4b5eAYwkPPk=";

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
