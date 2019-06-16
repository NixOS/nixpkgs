{ stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "thanos";
  version = "0.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "improbable-eng";
    repo = "thanos";
    sha256 = "0my0653mkb14m93s4x3nyf8khyljkvi5sq049lir8yqzqn7p1654";
  };

  modSha256 = "1236cg00h8077fmvyddwjsnw85r69ac18b2chcpgzd85xdcaxavk";

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
    homepage = "https://github.com/improbable-eng/thanos";
    license = licenses.asl20;
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.unix;
  };
}
