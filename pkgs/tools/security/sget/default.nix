{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "sget";
  version = "unstable-2022-10-04";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "d7d1e53b21ca906000e74474729854cb5ac48dbc";
    sha256 = "sha256-BgxTlLmtKqtDq3HgLoH+j0vBrpRujmL9Wr8F4d+jPi0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-KPQHS7Hfco1ljOJgStIXMaol7j4dglcr0w+6Boj7GK8=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd sget \
      --bash <($out/bin/sget completion bash) \
      --fish <($out/bin/sget completion fish) \
      --zsh <($out/bin/sget completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/sget";
    description = "Command for safer, automatic verification of signatures and integration with Sigstore's binary transparency log, Rekor";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
