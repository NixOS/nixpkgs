{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "telegraf-${version}";
  version = "1.4.4";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "${version}";
    sha256 = "1hyjbx0hwyh39dgij86xlznaqnzh8m0yk96phqgxs328dlcxfl07";
  };

  buildFlagsArray = [ ''-ldflags=
    -X main.version=${version}
  '' ];

  goDeps = ./. + builtins.toPath "/deps-${version}.nix";

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics.";
    license = licenses.mit;
    homepage = https://www.influxdata.com/time-series-platform/telegraf/;
    maintainers = with maintainers; [ mic92 roblabla ];
    platforms = platforms.linux;
  };
}
