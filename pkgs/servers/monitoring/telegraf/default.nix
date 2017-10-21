{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "telegraf-${version}";
  version = "1.4.2";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "${version}";
    sha256 = "1lmk0czqbr4mn1zf99403r8s6nyyk3bxwgvxfx7w4apvxl433iw4";
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
