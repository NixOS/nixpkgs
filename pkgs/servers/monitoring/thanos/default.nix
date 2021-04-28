{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "thanos";
  version = "0.19.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thanos-io";
    repo = "thanos";
    sha256 = "sha256-FryVKOabokw2+RyD94QLVpC9ZGIHPuSXZf5H+eitj80=";
  };

  vendorSha256 = "sha256-GBjPMZ6BwUOKywNf1Bc2WeA14qvKQ0R5gWvVxgO/7Lo=";

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

  meta = with lib; {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = "https://github.com/thanos-io/thanos";
    license = licenses.asl20;
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.unix;
  };
}
