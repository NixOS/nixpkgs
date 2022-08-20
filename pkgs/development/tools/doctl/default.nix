{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "doctl";
  version = "1.79.0";

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "cmd/doctl" ];

  ldflags = let t = "github.com/digitalocean/doctl"; in [
    "-X ${t}.Major=${lib.versions.major version}"
    "-X ${t}.Minor=${lib.versions.minor version}"
    "-X ${t}.Patch=${lib.versions.patch version}"
    "-X ${t}.Label=release"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    export HOME=$(mktemp -d) # attempts to write to /homeless-shelter
    for shell in bash fish zsh; do
      $out/bin/doctl completion $shell > doctl.$shell
      installShellCompletion doctl.$shell
    done
  '';

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "doctl";
    rev = "v${version}";
    sha256 = "sha256-0tl79nVvnY2KECrfgEXQ8tOHnwEX+34uiJ/jshK5oFA=";
  };

  meta = with lib; {
    description = "A command line tool for DigitalOcean services";
    homepage = "https://github.com/digitalocean/doctl";
    license = licenses.asl20;
    maintainers = [ maintainers.siddharthist ];
  };
}
