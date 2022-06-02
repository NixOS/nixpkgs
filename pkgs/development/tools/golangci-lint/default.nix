{ stdenv, buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.46.2";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "sha256-7sDAwWz+qoB/ngeH35tsJ5FZUfAQvQsU6kU9rUHIHMk=";
  };

  vendorSha256 = "sha256-w38OKN6HPoz37utG/2QSPMai55IRDXCIIymeMe6ogIU=";

  doCheck = false;

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" "-X main.date=19700101-00:00:00"
  ];

  postInstall = ''
    for shell in bash zsh fish; do
      HOME=$TMPDIR $out/bin/golangci-lint completion $shell > golangci-lint.$shell
      installShellCompletion golangci-lint.$shell
    done
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ anpryl manveru mic92 ];
  };
}
