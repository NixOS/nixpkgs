{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.1.0-beta.5";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "${version}";
    sha256 = "1q9zjxxjxa5kkhlsh69bvgns3kzf23z84jjzg294qb7y7xypym5q";
  };

  vendorSha256 = "sha256:0y5rq2y48kf2z1z3a8ags6rqzfvjs54klk2679fk8x0yjamj5x04";

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
