{ lib, fetchFromGitHub, installShellFiles, buildGoModule }:

buildGoModule rec {
  pname = "autorestic";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "cupcakearmy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0eq2u3DCNgfxsiE4lycf+xGIoEC3sZgEMha9+40j+9s=";
  };

  vendorSha256 = "sha256-qYXdRpQT7x+Y5h8PuKGjsANXLqjNlsPKO76GQhnufTU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd autorestic \
         --bash <($out/bin/autorestic completion bash) \
         --fish <($out/bin/autorestic completion fish) \
         --zsh <($out/bin/autorestic completion zsh)
  '';

  meta = with lib; {
    description = "High level CLI utility for restic";
    homepage = "https://github.com/cupcakearmy/autorestic";
    license = licenses.asl20;
    maintainers = with maintainers; [ renesat ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
