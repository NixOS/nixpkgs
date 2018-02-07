{ stdenv, lib, buildGoPackage, consul-ui, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-${version}";
  version = "0.9.3";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul";
    inherit rev;
    sha256 = "1176frp7kimpycsmz9wrbizf46jgxr8jq7hz5w4q1x90lswvrxv3";
  };

  # Keep consul.ui for backward compatability
  passthru.ui = consul-ui;

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X github.com/hashicorp/consul/version.GitDescribe=v${version} -X github.com/hashicorp/consul/version.Version=${version} -X github.com/hashicorp/consul/version.VersionPrerelease=")
  '';

  meta = with stdenv.lib; {
    description = "Tool for service discovery, monitoring and configuration";
    homepage = https://www.consul.io/;
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
