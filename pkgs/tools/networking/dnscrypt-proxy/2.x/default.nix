{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dnscrypt-proxy2-${version}";
  version = "2.0.15";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dnscrypt-proxy";
    rev = "${version}";
    sha256 = "0iwvndk1h550zmwhwablb0smv9n2l51hqbmzj354mcgi6frnx819";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = https://dnscrypt.info/;
    maintainers = with maintainers; [ waynr ];
    platforms = with platforms; unix;
  };
}
