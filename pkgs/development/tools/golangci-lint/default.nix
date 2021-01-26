{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.35.2";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "sha256-UntDMiznrHZsaBFTcnNhnh59j+yY1zdpWrFNlalxTDA=";
  };

  vendorSha256 = "sha256-6YacyQqTq9WQk8PgvoIxflh6HRmv5xgxtWq6HrprJis=";

  doCheck = false;

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev} -X main.date=19700101-00:00:00" ];

  postInstall = ''
    for shell in bash zsh; do
      HOME=$TMPDIR $out/bin/golangci-lint completion $shell > golangci-lint.$shell
      installShellCompletion golangci-lint.$shell
    done
  '';

  meta = with lib; {
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
