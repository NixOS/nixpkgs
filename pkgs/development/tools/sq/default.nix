{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testVersion, sq }:
buildGoModule rec {
  pname = "sq";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4CINLOHUVXQ+4e5I1fMqog6LubMm8RnbFmeuBOwALaw=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-lNpWXKtnzwySzinNPxAKuaLqweWuS6zz8s2W4xXWlqM=";

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
    version = testVersion { package = sq; };
  };

  meta = with lib; {
    description = "Swiss army knife for data";
    homepage = "https://sq.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
