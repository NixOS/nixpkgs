{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dnscrypt-proxy2";
  version = "2.0.25";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "1ix76nihzjbiib7n2pjx2ynziz8hrrx3idwdjnkwckxfq11g96y3";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = https://dnscrypt.info/;
    maintainers = with maintainers; [ waynr ];
    platforms = with platforms; unix;
  };
}
