{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fritzbox-exporter-${version}";
  version = "1.0";
  rev = "v${version}";

  goPackagePath = "github.com/ndecker/fritzbox_exporter";

  src= fetchFromGitHub {
    inherit rev;
    owner = "ndecker";
    repo = "fritzbox_exporter";
    sha256 = "1qk3dgxxz3cnz52jzz0yvfkrkk4s5kdhc26nbfgdpn0ifzqj0awr";
  };

  meta = with stdenv.lib; {
    description = "FRITZ!Box UPnP statistics exporter for prometheus";
    homepage = https://github.com/ndecker/fritzbox_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.unix;
  };
}
