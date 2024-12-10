{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "changelogger";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "MarkusFreitag";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XDiO8r1HpdsfBKzFLnsWdxte2EqL1blPH21137fNm5M=";
  };

  vendorHash = "sha256-E6J+0tZriskBnXdhQOQA240c3z+laXM5honoREjHPfM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/MarkusFreitag/changelogger/cmd.BuildVersion=${version}"
    "-X github.com/MarkusFreitag/changelogger/cmd.BuildDate=1970-01-01T00:00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd changelogger \
      --bash <($out/bin/changelogger completion bash) \
      --fish <($out/bin/changelogger completion fish) \
      --zsh <($out/bin/changelogger completion zsh)
  '';

  meta = with lib; {
    description = "A tool to manage your changelog file in Markdown";
    homepage = "https://github.com/MarkusFreitag/changelogger";
    changelog = "https://github.com/MarkusFreitag/changelogger/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomsiewert ];
    mainProgram = "changelogger";
  };
}
