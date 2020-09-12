{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "10divgsc095jiw7n3gwzikbgvsd0hdwjyv469vq939zm7rqq3acy";
  };

  vendorSha256 = "1pa99jfz6i696x6v06aq56r0kmxmz4khb1hw7pvxds0bn16a4swr";

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
