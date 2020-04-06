{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dnscrypt-proxy2";
  version = "2.0.42";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "1v4n0pkwcilxm4mnj4fsd4gf8pficjj40jnmfkiwl7ngznjxwkyw";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = https://dnscrypt.info/;
    maintainers = with maintainers; [ atemu waynr ];
    platforms = with platforms; unix;
  };
}
