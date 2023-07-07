{ lib, stdenv, fetchurl, zig, ncurses }:

zig.buildZigPackage rec {
  pname = "ncdu";
  version = "2.2.2";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    hash = "sha256-kNkgAk51Ixi0aXds5X4Ds8cC1JMprZglruqzbDur+ZM=";
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub SuperSandro2000 rodrgz ];
  };
}
