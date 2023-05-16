{ lib
, kaem
, mes
}:
let
  pname = "ln-boot";
<<<<<<< HEAD
  version = "unstable-2023-05-22";
=======
  version = "unstable-2023-05-01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = ./ln.c;
in
kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  meta = with lib; {
    description = "Basic tool for creating symbolic links";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = teams.minimal-bootstrap.members;
=======
    maintainers = with maintainers; [ emilytrau ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "ln";
    platforms = platforms.unix;
  };
} ''
  mkdir -p ''${out}/bin
<<<<<<< HEAD
  ${mes.compiler}/bin/mes --no-auto-compile -e main ${mes.srcPost.bin}/bin/mescc.scm -- \
    -L ${mes.libs}/lib \
=======
  ${mes}/bin/mes --no-auto-compile -e main ${mes}/bin/mescc.scm -- \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    -lc+tcc \
    -o ''${out}/bin/ln \
    ${src}
''
