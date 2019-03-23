{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dnscrypt-proxy2-${version}";
  version = "2.0.21";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dnscrypt-proxy";
    rev = "${version}";
    sha256 = "00sz5gn4l56rp4xcvxfpq6c64inpgzbwpqy1yc5sima6ijrayi9g";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = https://dnscrypt.info/;
    maintainers = with maintainers; [ waynr ];
    platforms = with platforms; unix;
  };
}
