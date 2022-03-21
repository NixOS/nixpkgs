{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    sha256 = "sha256-9NsudhalFm0km7BmK+2QzK9LxirrVtIFzNrugpw4f8g=";
  };

  vendorSha256 = "sha256-SUbQPzFZUBgFZvaLc8730hZhJvt3/ni306Vt3EZMOmU=";

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
