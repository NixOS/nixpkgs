{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, sq }:

buildGoModule rec {
  pname = "sq";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KPH1IsvYQvyUsi4qxWKLpCQNrPCnulCqQLPK5iadm3I=";
  };

  vendorHash = "sha256-AL4ghkeTIkXZXpGeBnWIx3hY6uO2bO7eVcH6DR/5jQc=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd sq \
      --bash <($out/bin/sq completion bash) \
      --fish <($out/bin/sq completion fish) \
      --zsh <($out/bin/sq completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion { package = sq; };
  };

  meta = with lib; {
    description = "Swiss army knife for data";
    homepage = "https://sq.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
