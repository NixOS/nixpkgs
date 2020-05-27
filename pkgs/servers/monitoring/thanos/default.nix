{ stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "thanos";
  version = "0.12.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thanos-io";
    repo = "thanos";
    sha256 = "10xscm9h2krha66v96v2q85fynnxfizjcc47h7yz4xhjwvb5dgz2";
  };

  vendorSha256 = "126rghnyjpykvjg9sr4kwpskc13qqafxgfn9ffykwc4jjz8vc07q";

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