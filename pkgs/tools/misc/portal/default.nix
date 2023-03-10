{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "portal";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "SpatiumPortae";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-80ZWMYGH5D5C5Lw97Sic3duw+oXBzIxQjJ+6uQLBwJQ=";
  };

  vendorSha256 = "sha256-SbNFi5DE3zhTUw0rsX6n+dpYcdDsaDh+zVUrfxgo/4g=";
  subPackages = [ "cmd/portal/" ];

  ldflags = [ "-s -X main.version=${version}" ]; # from: https://github.com/SpatiumPortae/portal/blob/master/Makefile#L3

  meta = with lib; {
    description = "A quick and easy command-line file transfer utility from any computer to another";
    homepage = "https://github.com/SpatiumPortae/portal";
    changelog = "https://github.com/SpatiumPortae/portal/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tennox ];
  };
}
