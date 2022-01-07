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

  meta = with lib; {
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    description = "A command-line exact real calculator";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres mcbeth ];
    platforms = platforms.unix;
  };
}
