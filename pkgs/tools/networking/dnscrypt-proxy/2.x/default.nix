{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "dnscrypt-proxy-${version}";
  version = "2.0.17";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchzip {
    url = "https://${goPackagePath}/archive/${version}.tar.gz";
    sha256 = "12mg1jbla2hyq44wq9009sqb0mzwq16wi8shafabwk0zf9s2944d";
  };

  meta = with stdenv.lib; {
    description = "DNS over HTTPS and DNSCrypt proxy";
    license = licenses.isc;
    maintainers = with maintainers; [ waynr yegortimoshenko ];
  };
}
