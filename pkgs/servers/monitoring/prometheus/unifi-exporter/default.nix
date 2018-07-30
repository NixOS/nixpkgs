{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "unifi-exporter-${version}";
  version = "0.4.0+git1";
  rev = "9a4e69fdea91dd0033bda4842998d751b40a6130";

  goPackagePath = "github.com/mdlayher/unifi_exporter";

  src= fetchFromGitHub {
    inherit rev;
    owner = "mdlayher";
    repo = "unifi_exporter";
    sha256 = "08zqvwvdqnc301f8jfh7bdvc138szw6xszx884b2v8w2x38w3rmn";
  };

  meta = with stdenv.lib; {
    description = "Prometheus exporter that exposes metrics from a Ubiquiti UniFi Controller and UniFi devices";
    homepage = https://github.com/mdlayher/unifi_exporter;
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.unix;
  };
}
