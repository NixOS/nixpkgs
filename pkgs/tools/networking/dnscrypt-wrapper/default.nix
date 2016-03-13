{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libsodium, libevent }:

stdenv.mkDerivation rec {
  name = "dnscrypt-wrapper-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Cofyc";
    repo = "dnscrypt-wrapper";
    rev = "v${version}";
    sha256 = "06m6p79y0p6f1knk40fbi7dnc5hnq066kafvrq74fxrl51nywjbg";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ libsodium libevent ];

  meta = with stdenv.lib; {
    description = "A tool for adding dnscrypt support to any name resolver";
    homepage = https://dnscrypt.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ tstrobel joachifm ];
    platforms = platforms.linux;
  };
}
