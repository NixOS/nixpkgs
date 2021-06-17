{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "sha256-ogH3L2EG0xdGpCaEfMUYnCWyFTGgx/C/O54mMxcJSBA=";
  };

  vendorSha256 = "sha256-gYulktNetcgXk43Ydk4+WEMZMFCrmx6p5VnsFIJdQhk=";

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
