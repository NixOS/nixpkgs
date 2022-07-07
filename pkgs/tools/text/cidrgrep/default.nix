{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "cidrgrep";
  version = "unstable-2020-11-17";

  src = fetchFromGitHub {
    owner = "tomdoherty";
    repo = "cidrgrep";
    rev = "8ad5af533e8dc33ea18ff19b7c6a41550748fe0e";
    hash = "sha256-Bp1cST6/8ppvpgNxjUpwL498C9vTJmoWOKLJgmWqfEs=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  postInstall = ''
    mv $out/bin/cmd $out/bin/cidrgrep
  '';

  meta = {
    description = "Like grep but for IPv4 CIDRs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ das_j ];
  };
}
