{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "consul";
  version = "1.9.5";
  rev = "v${version}";

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
    sha256 = "sha256-CKezHuCbL1I79gDz7ZQiSgPbSXo0NtssQro2MqqmeXw=";
  };

  passthru.tests.consul = nixosTests.consul;

  # This corresponds to paths with package main - normally unneeded but consul
  # has a split module structure in one repo
  subPackages = ["." "connect/certgen"];

  vendorSha256 = "sha256-YqrW3PeFv1Y6lmjVmMMP0SZao57iPqfut3a1afIWkI0=";

  doCheck = false;

  deleteVendor = true;

  preBuild = ''
    buildFlagsArray+=("-ldflags"
                      "-X github.com/hashicorp/consul/version.GitDescribe=v${version}
                       -X github.com/hashicorp/consul/version.Version=${version}
                       -X github.com/hashicorp/consul/version.VersionPrerelease=")
  '';

  meta = with lib; {
    description = "Tool for service discovery, monitoring and configuration";
    homepage = "https://www.consul.io/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri vdemeester nh2 ];
  };
}
