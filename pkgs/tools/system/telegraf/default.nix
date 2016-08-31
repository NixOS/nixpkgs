{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "telegraf-${version}";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "${version}";
    sha256 = "1zdb85wkx5q7c799sn695ckzym6avqz05xlvw0d1p919c2ilba9f";
  };

  goPackagePath = "github.com/influxdata/telegraf";

  # Generated with the `gdm2nix.rb` script and the `Godeps` file from the
  # influxdb repo root.
  goDeps = ./deps.json;

  meta = with lib; {
    description = " The plugin-driven server agent for collecting & reporting metrics. ";
    license = licenses.mit;
    homepage = https://github.com/influxdata/telegraf;
    maintainers = with maintainers; [ roblabla ];
    platforms = platforms.linux;
  };
}
