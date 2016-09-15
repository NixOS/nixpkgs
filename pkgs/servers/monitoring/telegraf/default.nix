{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "telegraf-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "${version}";
    sha256 = "0kbh4gba4rrbykdl9wsyijh0xi5ksrch99fn4gj5gbbmd383pdzv";
  };

  # Generated with the `gdm2nix.rb` script and the `Godeps` file from the influxdb repo root.
  goDeps = ./. + builtins.toPath "/deps-${version}.nix";

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics.";
    license = licenses.mit;
    homepage = https://www.influxdata.com/time-series-platform/telegraf/;
    maintainers = with maintainers; [ mic92 roblabla ];
    platforms = platforms.linux;
  };
}
