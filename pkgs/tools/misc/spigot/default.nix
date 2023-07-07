{ lib
, stdenv
, fetchurl
, cmake
, gmp
, halibut
, ncurses
, perl
}:

stdenv.mkDerivation rec {
  pname = "spigot";
  version = "20210527";
  srcVersion = "20210527.7dd3cfd";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/${pname}-${srcVersion}.tar.gz";
    hash = "sha256-EBS3lgfLtsyBQ8mzoJPyZhRBJNmkVSeF5XecGgcvqtw=";
  };

  nativeBuildInputs = [
    cmake
    halibut
    perl
  ];

  buildInputs = [
    gmp
    ncurses
  ];

  outputs = [ "out" "man" ];

  strictDeps = true;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    [ `$out/bin/spigot -b 10 -d 10 e` == "2.7182818284" ] || exit 1
    [ `$out/bin/spigot -b 10 -d 10 pi` == "3.1415926535" ] || exit 1
    [ `$out/bin/spigot -b 10 -d 10 sqrt\(2\)` == "1.4142135623" ] || exit 1

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    description = "A command-line exact real calculator";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres mcbeth ];
    platforms = platforms.unix;
  };
}
