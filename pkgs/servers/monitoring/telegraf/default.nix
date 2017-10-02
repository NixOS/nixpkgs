{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "telegraf-${version}";
  version = "1.4.1";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "${version}";
    sha256 = "1q0xl599zyqyralsl6mml1xl0h2206564sa2azivjmg48z7blcll";
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
