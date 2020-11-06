{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256:00mhkp3nf6h2zsvmmwyza1lahvmm05isfi7rqkx24c0dmkmif3x9";
  };

  vendorSha256 = "sha256:1ilciwf08678sciwwrjalwvcs5bp7x254nxc3nhdf88cf0bp2nxi";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/timescale/promscale/pkg/version.Version=${version} -X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}" ];

  doCheck = false; # Requires access to a docker daemon

  meta = with stdenv.lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
