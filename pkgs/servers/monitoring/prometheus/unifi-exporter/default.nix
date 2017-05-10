{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "unifi-exporter-${version}";
  version = "0.4.0+21";
  rev = "1a38790c49f06d64c517cd88de9e3f9d2677e105";

  goPackagePath = "github.com/mdlayher/unifi_exporter";

  src= fetchFromGitHub {
    inherit rev;
    owner = "mdlayher";
    repo = "unifi_exporter";
    sha256 = "1692w9hzl3xqywn3p6zdi2l77f3xy7j42429wy2c0ny0mljbzv7p";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Prometheus exporter that exposes metrics from a Ubiquiti UniFi Controller and UniFi devices";
    homepage = https://github.com/mdlayher/unifi_exporter;
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.unix;
  };
}
