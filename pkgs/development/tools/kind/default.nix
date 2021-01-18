{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

with stdenv.lib;

buildGoModule rec {
  pname = "kind";
  version = "0.9.0";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "1kyjmlp1kmr3lwylnya6w392j1qpqgbvcacwpnz3ifyh3pbv32qr";
  };

  vendorSha256 = "04fmqh6lhvvzpvf1l2xk1r8687k5jx2lb5199rgmjbfnjgsa0q2d";

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kind completion $shell > kind.$shell
      installShellCompletion kind.$shell
    done
  '';

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [ offline rawkode ];
    license     = stdenv.lib.licenses.asl20;
    platforms   = platforms.unix;
  };
}
