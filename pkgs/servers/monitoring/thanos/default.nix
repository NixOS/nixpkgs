{ stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "thanos";
  version = "0.17.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thanos-io";
    repo = "thanos";
    sha256 = "06pr9zqfd7nq13pgg02px2d9rp7phxlmnirpkdfgbw799zrfvpag";
  };

  vendorSha256 = "1j3gnzas0hpb5dljf5m97nw2v4r1bp3l99z36gbqkm6lqzr6hqk8";

  doCheck = false;

  subPackages = "cmd/thanos";

  buildFlagsArray = let t = "github.com/prometheus/common/version"; in ''
    -ldflags=
       -X ${t}.Version=${version}
       -X ${t}.Revision=unknown
       -X ${t}.Branch=unknown
       -X ${t}.BuildUser=nix@nixpkgs
       -X ${t}.BuildDate=unknown
  '';

  meta = with stdenv.lib; {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = "https://github.com/thanos-io/thanos";
    license = licenses.asl20;
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.unix;
  };
}
