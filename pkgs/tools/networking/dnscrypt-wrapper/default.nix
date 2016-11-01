{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libsodium, libevent }:

stdenv.mkDerivation rec {
  name = "dnscrypt-wrapper-${version}";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Cofyc";
    repo = "dnscrypt-wrapper";
    rev = "v${version}";
    sha256 = "0ip205safbpkmk1z7qf3hshqlc2q2zwhsm3i705m0y7rxc4200ms";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ libsodium libevent ];

  meta = with stdenv.lib; {
    description = "A tool for adding dnscrypt support to any name resolver";
    homepage = https://dnscrypt.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ tstrobel joachifm ];
    platforms = platforms.linux;
  };
}
