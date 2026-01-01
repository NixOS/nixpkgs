{
  lib,
  fetchurl,
  kaem,
  nyacc,
}:
let
  pname = "nyacc";
  # NYACC is a tightly coupled dependency of mes. This version is known to work
<<<<<<< HEAD
  # with mes 0.27.1.
  # https://git.savannah.gnu.org/cgit/mes.git/tree/INSTALL?h=v0.27.1#n31
  #
  # Note: mes has issues with NYACC 1.09.2 and up. The mes interpreter cannot
  # parse block comments outside top level. This seems to be fixed in development
  # versions of mes.
  # https://gitlab.com/janneke/commencement.scm/-/blob/fdc718f050171f12da58524f60c4d52c03e83df3/gcc-bootstrap.scm#L621
  version = "1.09.1";

  src = fetchurl {
    url = "mirror://savannah/nyacc/nyacc-${version}.tar.gz";
    hash = "sha256-DsmuU34NlReBpQ3jx5KayXqFwdS16F5dUVQuN1ECJxc=";
=======
  # with mes 0.25.
  # https://git.savannah.gnu.org/cgit/mes.git/tree/INSTALL?h=v0.25#n31
  version = "1.00.2";

  src = fetchurl {
    url = "mirror://savannah/nyacc/nyacc-${version}.tar.gz";
    sha256 = "065ksalfllbdrzl12dz9d9dcxrv97wqxblslngsc6kajvnvlyvpk";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
kaem.runCommand "${pname}-${version}"
  {
    inherit pname version;

    passthru.guilePath = "${nyacc}/share/${pname}-${version}/module";

<<<<<<< HEAD
    meta = {
=======
    meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      description = "Modules for generating parsers and lexical analyzers";
      longDescription = ''
        Not Yet Another Compiler Compiler is a set of guile modules for
        generating computer language parsers and lexical analyzers.
      '';
      homepage = "https://savannah.nongnu.org/projects/nyacc";
<<<<<<< HEAD
      license = lib.licenses.lgpl3Plus;
      teams = [ lib.teams.minimal-bootstrap ];
      platforms = lib.platforms.all;
=======
      license = licenses.lgpl3Plus;
      teams = [ teams.minimal-bootstrap ];
      platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  }
  ''
    ungz --file ${src} --output nyacc.tar
    mkdir -p ''${out}/share
    cd ''${out}/share
    untar --file ''${NIX_BUILD_TOP}/nyacc.tar
  ''
