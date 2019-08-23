{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  name    = "smimesign-${version}";
  version = "v0.0.13";

  src = fetchFromGitHub {
    owner  = "github";
    repo   = "smimesign";
    rev    = version;
    sha256 = "0higcg2rdz02c0n50vigg7w7bxc7wlmg1x2ygrbh3iwms5lc74vi";
  };

  modSha256 = "1k3gnjzblfk14y19zhlvwysx045nbw0xr5nngh7zj1wcqxhhm206";

  buildFlagsArray = "-ldflags=-X main.versionString=${version}";

  meta = with lib; {
    description = "An S/MIME signing utility for macOS and Windows that is compatible with Git.";

    homepage    = https://github.com/github/smimesign;
    license     = licenses.mit;
    platforms   = platforms.darwin;
    maintainers = [ maintainers.enorris ];
  };
}
