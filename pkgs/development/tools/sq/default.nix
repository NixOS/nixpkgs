{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, sq }:

buildGoModule rec {
  pname = "sq";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TD9brvMxU2gdiOiJPs/M5PmiwFd99P9YohCG7bcjLas=";
  };

  vendorHash = "sha256-/LsQfhU5+Wobts6R3cJDJaKSvPUqWNBpx9ILgNC2otc=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd sq \
      --bash <($out/bin/sq completion bash) \
      --fish <($out/bin/sq completion fish) \
      --zsh <($out/bin/sq completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = sq;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Swiss army knife for data";
    homepage = "https://sq.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
