<<<<<<< HEAD
{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config, nixosTests }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.20.0";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-5w1afLi3Hdfbq/01cdcaS2uZ8uhdjXGvHnNPbYZjXw4=";
=======
{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.19.0";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-rwsF6X0OH9mtRf4A6m0qk0xjB19n9+LM7yylnj2M5oI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ];
  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.tests = {
    pgbouncer = nixosTests.pgbouncer;
  };

  meta = with lib; {
    homepage = "https://www.pgbouncer.org/";
    description = "Lightweight connection pooler for PostgreSQL";
    changelog = "https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_${replaceStrings ["."] ["_"] version}";
=======
  meta = with lib; {
    homepage = "https://www.pgbouncer.org/";
    description = "Lightweight connection pooler for PostgreSQL";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.isc;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
  };
}
