{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dnscrypt-proxy2-${version}";
  version = "2.0.22";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "0rmiyqxbbc3gjnfvyggf2lckckliiijq528993gv0n875r7ahkix";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = https://dnscrypt.info/;
    maintainers = with maintainers; [ waynr ];
    platforms = with platforms; unix;
  };
}
