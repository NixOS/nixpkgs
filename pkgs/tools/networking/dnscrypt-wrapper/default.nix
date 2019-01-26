{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libsodium, libevent }:

stdenv.mkDerivation rec {
  name = "dnscrypt-wrapper-${version}";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Cofyc";
    repo = "dnscrypt-wrapper";
    rev = "v${version}";
    sha256 = "055vxpcfg80b1456p6p0p236pwykknph9x3c9psg8ya3i8qqywkl";
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
