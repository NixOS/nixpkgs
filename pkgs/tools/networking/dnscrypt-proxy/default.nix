{ stdenv, fetchurl, libsodium }:

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-1.4.1";

  src = fetchurl {
    url = "http://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "00cf5c520c8a5a71ad4916b33aa0c8f9f55434039304f4ba10d7fffc620563f8";
  };

  buildInputs = [ libsodium ];

  meta = {
    description = "A DNS proxy which encrypts and authenticates requests using the DNSCrypt protocol.";
    homepage = http://dnscrypt.org/;
    license = with stdenv.lib.licenses; [ isc ];
    maintainers = with stdenv.lib.maintainers; [ joachifm ];
  };
}
