{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dgraph";
  version = "20.03.3";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "0z2zc0mf7ndf3cpzi1js396s1yxpgfjaj9jacifsi8v6i6r0c6cz";
  };

  # see licensing
  buildFlags = [ "-tags oss" ];
  buildFlagsArray = [ "-ldflags=" "-X github.com/dgraph-io/dgraph/x.dgraphVersion=${version}" ];

  vendorSha256 = "1nz4yr3y4dr9l09hcsp8x3zhbww9kz0av1ax4192f5zxpw1q275s";

  subPackages = [ 
    "dgraph" 
  ];

  meta = {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    # Apache 2.0 because we use only build tag "oss"
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
