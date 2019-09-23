{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "consul";
  version = "1.6.1";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul";

  # Note: Currently only release tags are supported, because they have the Consul UI
  # vendored. See
  #   https://github.com/NixOS/nixpkgs/pull/48714#issuecomment-433454834
  # If you want to use a non-release commit as `src`, you probably want to improve
  # this derivation so that it can build the UI's JavaScript from source.
  # See https://github.com/NixOS/nixpkgs/pull/49082 for something like that.
  # Or, if you want to patch something that doesn't touch the UI, you may want
  # to apply your changes as patches on top of a release commit.
  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev;
    sha256 = "00dvvxi7y80v2b6wzwyfzhxv1ksnl1m0nmdjl98dhq5ikb0v7p28";
  };

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X github.com/hashicorp/consul/version.GitDescribe=v${version} -X github.com/hashicorp/consul/version.Version=${version} -X github.com/hashicorp/consul/version.VersionPrerelease=")
  '';

  meta = with stdenv.lib; {
    description = "Tool for service discovery, monitoring and configuration";
    homepage = https://www.consul.io/;
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri vdemeester nh2 ];
  };
}
