{ lib
, fetchurl
, kaem
, nyacc
}:
let
  pname = "nyacc";
  # NYACC is a tightly coupled dependency of mes. This version is known to work
  # with mes 0.24.2.
  # https://git.savannah.gnu.org/cgit/mes.git/tree/INSTALL?h=v0.24.2&id=7562330ec746f09b4060d3081e3377fb7083897d#n31
  version = "1.00.2";

  src = fetchurl {
    url = "mirror://savannah/nyacc/nyacc-${version}.tar.gz";
    sha256 = "065ksalfllbdrzl12dz9d9dcxrv97wqxblslngsc6kajvnvlyvpk";
  };
in
kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  passthru.guilePath = "${nyacc}/share/${pname}-${version}/module";

  meta = with lib; {
    description = "Modules for generating parsers and lexical analyzers";
    longDescription = ''
      Not Yet Another Compiler Compiler is a set of guile modules for
      generating computer language parsers and lexical analyzers.
    '';
    homepage = "https://savannah.nongnu.org/projects/nyacc";
    license = licenses.lgpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.all;
  };
} ''
  ungz --file ${src} --output nyacc.tar
  mkdir -p ''${out}/share
  cd ''${out}/share
  untar --file ''${NIX_BUILD_TOP}/nyacc.tar
''
