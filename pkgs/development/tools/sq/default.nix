{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, sq }:

buildGoModule rec {
  pname = "sq";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h8rCHtBTckLjRxi79N26pYiCJSI/UKUbwUTsQXD7Sco=";
  };

  vendorHash = "sha256-VcqCscheXYgWT88ZExJWdwRMT5Ir0C49S5+Hp557jiw=";

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
