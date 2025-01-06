{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.18.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-fA+h6ynYWq7UuhdBZL27jwEbXDkNAXxX1mj8cjEzJAU=";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "ncdu";
  };
}
