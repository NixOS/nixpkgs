{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, sq }:

buildGoModule rec {
  pname = "sq";
  version = "0.47.4";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vOp1F87kg9ydr9caGefcYrRJY5foEbKkpMK0eCUzQpQ=";
  };

  vendorHash = "sha256-G623vH7pWpJbPvC8sR1xl6x3pcuBUvQwEj1RENuHnI8=";

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
    mainProgram = "sq";
    homepage = "https://sq.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
