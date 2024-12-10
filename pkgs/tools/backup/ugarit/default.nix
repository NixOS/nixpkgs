{
  lib,
  eggDerivation,
  fetchegg,
  z3,
}:

let
  eggs = import ./eggs.nix { inherit eggDerivation fetchegg; };
in

eggDerivation rec {
  pname = "ugarit";
  version = "2.0";
  name = "${pname}-${version}";

  src = fetchegg {
    inherit version;
    name = pname;
    sha256 = "1l5zkr6b8l5dw9p5mimbva0ncqw1sbvp3d4cywm1hqx2m03a0f1n";
  };

  buildInputs = with eggs; [
    aes
    crypto-tools
    matchable
    message-digest
    miscmacros
    parley
    pathname-expand
    posix-extras
    regex
    sha2
    sql-de-lite
    srfi-37
    ssql
    stty
    tiger-hash
    z3
  ];

  meta = with lib; {
    homepage = "https://www.kitten-technologies.co.uk/project/ugarit/";
    description = "A backup/archival system based around content-addressible storage";
    license = licenses.bsd3;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };
}
