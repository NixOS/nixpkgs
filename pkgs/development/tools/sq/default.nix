{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  sq,
}:

buildGoModule rec {
  pname = "sq";
  version = "0.48.3";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-22N8DEaLmGBA3Rx6VzxplUK9UAydo/gx4EsQzzaRHNE=";
  };

  vendorHash = "sha256-p0r7TuWFpV81Rnxqdj+UJec60EmvVQISURe43SpOpw0=";

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
