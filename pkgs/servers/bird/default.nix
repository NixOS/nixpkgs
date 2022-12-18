{ lib, stdenv, fetchurl, flex, bison, readline, libssh, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bird";
  version = "2.0.11";

  src = fetchurl {
    url = "ftp://bird.network.cz/pub/bird/${pname}-${version}.tar.gz";
    hash = "sha256-YKe4O2e50InSp0WhH93RJGH2MavHtkW2wIWt+Qs/VdY=";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ readline libssh ];

  patches = [
    ./dont-create-sysconfdir-2.patch
  ];

  CPP="${stdenv.cc.targetPrefix}cpp -E";

  configureFlags = [
    "--localstatedir=/var"
    "--runstatedir=/run/bird"
  ];

  passthru.tests = nixosTests.bird;

  meta = with lib; {
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${version}/NEWS";
    description = "BIRD Internet Routing Daemon";
    homepage = "http://bird.network.cz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.linux;
  };
}
