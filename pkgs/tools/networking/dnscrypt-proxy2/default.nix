{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscrypt-proxy2";
  version = "2.0.44";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "08bg60j5z349blj5sip1f8f793q12ix3zmqkayym5nf69s1pfm7l";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with maintainers; [ atemu waynr ];
    platforms = with platforms; unix;
  };
}
