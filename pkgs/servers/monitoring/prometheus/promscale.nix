{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256:0535sq640b9x9vi2sfazi9qs6arwjdn7nff16km2agncvs449dn4";
  };

  vendorSha256 = "sha256:1ilciwf08678sciwwrjalwvcs5bp7x254nxc3nhdf88cf0bp2nxi";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/timescale/promscale/pkg/version.Version=${version} -X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}" ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
