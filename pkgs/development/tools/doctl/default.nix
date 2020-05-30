{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "doctl";
  version = "1.43.0";

  vendorSha256 = null;

  subPackages = [ "cmd/doctl" ];

  buildFlagsArray = let t = "github.com/digitalocean/doctl"; in ''
    -ldflags=
    -X ${t}.Major=${lib.versions.major version}
    -X ${t}.Minor=${lib.versions.minor version}
    -X ${t}.Patch=${lib.versions.patch version}
    -X ${t}.Label=release
  '';

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
    sha256 = "1x8rr3707mmbfnjn3ck0953xkkrfq5r8zflbxpkqlfz9k978z835";
  };

  meta = with lib; {
    description = "A command line tool for DigitalOcean services";
    homepage = "https://github.com/digitalocean/doctl";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.siddharthist ];
  };
}
