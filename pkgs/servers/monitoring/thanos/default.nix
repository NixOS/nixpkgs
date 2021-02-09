{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "thanos";
  version = "0.18.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thanos-io";
    repo = "thanos";
    sha256 = "sha256-GJKTQGMmFJeUQn02GWP4KKpKdM8eT+VxDBDzST+5NXk=";
  };

  vendorSha256 = "sha256-s11iJFcJ1Ez6TkhCU3VD2ThU5/9otHz5rDF8z9ux79E=";

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
