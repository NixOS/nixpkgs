{ lib, fetchurl, buildPythonApplication, blivet }:

buildPythonApplication rec {
  pname = "nixpart";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/aszlig/nixpart/archive/v${version}.tar.gz";
    sha256 = "0avwd8p47xy9cydlbjxk8pj8q75zyl68gw2w6fnkk78dcb1a3swp";
  };

  propagatedBuildInputs = [ blivet ];

  meta = {
    description = "NixOS storage manager/partitioner";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.aszlig ];
    platforms = lib.platforms.linux;
  };
}
