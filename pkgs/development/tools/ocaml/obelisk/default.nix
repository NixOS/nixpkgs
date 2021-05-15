{ lib, fetchurl, ocamlPackages }:

ocamlPackages.buildDunePackage rec {
  pname = "obelisk";
  version = "0.5.2";
  useDune2 = true;
  src = fetchurl {
    url = "https://github.com/Lelio-Brun/Obelisk/releases/download/v${version}/obelisk-v${version}.tbz";
    sha256 = "0s86gkypyrkrp83xnay258ijri3yjwj3marsjnjf8mz58z0zd9g6";
  };

  buildInputs = with ocamlPackages; [ menhir re ];

  meta = {
    description = "A simple tool which produces pretty-printed output from a Menhir parser file (.mly)";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/Lelio-Brun/Obelisk";
  };
}
