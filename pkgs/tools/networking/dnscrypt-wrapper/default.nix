{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libsodium, libevent }:

stdenv.mkDerivation rec {
  name = "dnscrypt-wrapper-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Cofyc";
    repo = "dnscrypt-wrapper";
    rev = "v${version}";
    sha256 = "0wnkgn0ajx1qmfyb264jvpqxlbravdcq4m485iaa3wjp82g8xlca";
  };

  enableParallelBuilding = true;

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
