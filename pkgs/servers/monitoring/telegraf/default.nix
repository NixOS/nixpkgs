{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "telegraf-${version}";
  version = "1.2.1";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "${version}";
    sha256 = "0vfx87a9shhwyqrbdf1jc32jkg0ych8bd0p222v2rcd83l75r0kh";
  };

  goDeps = ./. + builtins.toPath "/deps-${version}.nix";

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics.";
    license = licenses.mit;
    homepage = https://www.influxdata.com/time-series-platform/telegraf/;
    maintainers = with maintainers; [ mic92 roblabla ];
    platforms = platforms.linux;
  };
}
