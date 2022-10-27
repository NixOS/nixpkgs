{ lib, stdenv, fetchurl, flex, bison, readline, libssh, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bird";
  version = "2.0.10";

  src = fetchurl {
    sha256 = "sha256-ftNB3djch/qXNlhrNRVEeoQ2/sRC1l9AIhVaud4f/Vo=";
    url = "ftp://bird.network.cz/pub/bird/${pname}-${version}.tar.gz";
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
    description = "BIRD Internet Routing Daemon";
    homepage = "http://bird.network.cz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.linux;
  };
}
