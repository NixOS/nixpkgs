{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libsodium, libevent, dnscrypt-wrapper, testVersion }:

stdenv.mkDerivation rec {
  pname = "dnscrypt-wrapper";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Cofyc";
    repo = "dnscrypt-wrapper";
    rev = "v${version}";
    sha256 = "055vxpcfg80b1456p6p0p236pwykknph9x3c9psg8ya3i8qqywkl";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ libsodium libevent ];

  passthru.tests.version = testVersion { package = dnscrypt-wrapper; };

  meta = with lib; {
    description = "A tool for adding dnscrypt support to any name resolver";
    homepage = "https://dnscrypt.info/";
    license = licenses.isc;
    maintainers = with maintainers; [ tstrobel joachifm ];
    platforms = platforms.linux;
  };
}
