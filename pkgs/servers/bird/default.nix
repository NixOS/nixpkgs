{ lib, stdenv, fetchurl, fetchpatch, flex, bison, readline, libssh, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bird";
  version = "2.0.9";

  src = fetchurl {
    sha256 = "sha256-dnhrvN7TBh4bsiGwEfLMACIewGPenNoASn2bBhoJbV4=";
    url = "ftp://bird.network.cz/pub/bird/${pname}-${version}.tar.gz";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ readline libssh ];

  patches = [
    (./. + "/dont-create-sysconfdir-${builtins.substring 0 1 version}.patch")
  ];

  CPP="${stdenv.cc.targetPrefix}cpp -E";

  configureFlags = [
    "--localstatedir=/var"
    "--runstatedir=/run/bird"
  ];

  passthru.tests = nixosTests.bird;

  meta = with lib; {
    description = "BIRD Internet Routing Daemon";
    homepage = "http://bird.network.cz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.linux;
  };
}
