{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "openvpn_exporter-unstable-${version}";
  version = "2017-05-15";
  rev = "a2a179a222144fa9a10030367045f075375a2803";

  goPackagePath = "github.com/kumina/openvpn_exporter";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/kumina/openvpn_exporter";
    sha256 = "1cjx7ascf532a20wwzrsx3qqs6dr04jyf700s3jvlvhhhx43l8m4";
  };

  goDeps = ./openvpn-exporter-deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for OpenVPN";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz ];
  };
}
