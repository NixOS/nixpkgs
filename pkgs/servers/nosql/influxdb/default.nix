{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "influxdb-${version}";
  version = "0.13.0";

  goPackagePath = "github.com/influxdata/influxdb";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "0f7af5jb1f65qnslhc7zccml1qvk6xx5naczqfsf4s1zc556fdi4";
  };

  excludedPackages = "test";

  # Generated with the `gdm2nix.rb` script and the `Godeps` file from the
  # influxdb repo root.
  goDeps = ./deps.json;

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = https://influxdb.com/;
    maintainers = with maintainers; [ offline zimbatm ];
    platforms = platforms.linux;
  };
}
