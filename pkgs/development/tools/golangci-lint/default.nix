{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.41.1";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "sha256-7xokU2uw7oiXhirTKuNfqJ143PlnI7M1zSixT0S6jtE=";
  };

  vendorSha256 = "sha256-s0ZFQJIhF23FtLol1Gegljf6eyGkCmVxTKmHbQBtPvM=";

  doCheck = false;

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    buildFlagsArray+=("-ldflags=-s -w -X main.version=${version} -X main.commit=v${version} -X main.date=19700101-00:00:00")
  '';

  postInstall = ''
    for shell in bash zsh; do
      HOME=$TMPDIR $out/bin/golangci-lint completion $shell > golangci-lint.$shell
      installShellCompletion golangci-lint.$shell
    done
  '';

  meta = with lib; {
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ anpryl manveru mic92 ];
  };
}
