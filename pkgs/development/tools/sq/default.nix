{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, sq }:
buildGoModule rec {
  pname = "sq";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QEg80di2DmMfIrvsRFp7nELs7LiJRVa/wENDnf1zQ2Y=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-P1NxcjRA0g9NK2EaEG5E9G2TywTp5uvHesQE7+EG4ag=";

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s" "-w" "-X github.com/neilotoole/sq/cli/buildinfo.Version=${version}"
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
