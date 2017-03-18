{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "unifi-exporter-${version}";
  version = "0.4.0";
  rev = version;

  goPackagePath = "github.com/mdlayher/unifi_exporter";

  src= fetchFromGitHub {
    inherit rev;
    owner = "mdlayher";
    repo = "unifi_exporter";
    sha256 = "0mbav3dkrwrgzzl80q590467nbq5j61v5v7mpsbhcn2p7ak0swx4";
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
