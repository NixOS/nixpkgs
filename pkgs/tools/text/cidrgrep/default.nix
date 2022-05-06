{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "cidrgrep";
  version = "unstable-2020-11-17";

  src = fetchFromGitHub {
    owner = "tomdoherty";
    repo = "cidrgrep";
    rev = "8ad5af533e8dc33ea18ff19b7c6a41550748fe0e";
    sha256 = "sha256:0jvwm9jq5jd270b6l9nkvc5pr3rgf158sw83lrprmwmz7r4mr786";
  };

  vendorSha256 = "sha256:0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  postInstall = ''
    mv $out/bin/cmd $out/bin/cidrgrep
  '';

  meta = {
    description = "Like grep but for IPv4 CIDRs";
    maintainers = with lib.maintainers; [ das_j ];
    license = lib.licenses.mit;
  };
}
