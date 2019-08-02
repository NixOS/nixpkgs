{ stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "thanos";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "improbable-eng";
    repo = "thanos";
    sha256 = "0vcp7m8fsk4jyk49jh9wmbvkx5k03xw10f4lbsxfmwib1y5pz2x0";
  };

  modSha256 = "139b66jdryqv4s1hjbn9fzkyzn1160wr4z6a6wmmvm3f6p6wgjxp";

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
