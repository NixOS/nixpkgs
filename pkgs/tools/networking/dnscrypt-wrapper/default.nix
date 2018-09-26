{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libsodium, libevent }:

stdenv.mkDerivation rec {
  name = "dnscrypt-wrapper-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Cofyc";
    repo = "dnscrypt-wrapper";
    rev = "v${version}";
    sha256 = "187sq99zxdfv3xhq939rybb0pps3l6wgyyvbj3zns5jr6mms64vd";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ libsodium libevent ];

  meta = with stdenv.lib; {
    description = "A tool for adding dnscrypt support to any name resolver";
    homepage = https://dnscrypt.info/;
    license = licenses.isc;
    maintainers = with maintainers; [ tstrobel joachifm ];
    platforms = platforms.linux;
  };
}
