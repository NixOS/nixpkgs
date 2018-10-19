{ stdenv, buildGoPackage, consul-ui, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-${version}";
  version = "1.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul";
    inherit rev;
    sha256 = "1zv84snvrjm74w3v3rr27linsbxj00m73xd047sb78a4766xs2h0";
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
    maintainers = with maintainers; [ pradeepchhetri vdemeester ];
  };
}
