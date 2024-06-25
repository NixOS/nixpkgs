{ lib
, stage0-posix
, mes
}:
let
  pname = "ln-boot";
  version = "unstable-2023-05-22";

  src = ./ln.c;
in
stage0-posix.kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  meta = with lib; {
    description = "Basic tool for creating symbolic links";
    license = licenses.mit;
    maintainers = teams.minimal-bootstrap.members;
    mainProgram = "ln";
    platforms = platforms.unix;
  };
} ''
  mkdir -p ''${out}/bin
  ${mes.compiler}/bin/mes --no-auto-compile -e main ${mes.srcPost.bin}/bin/mescc.scm -- \
    -L ${mes.libs}/lib \
    -lc+tcc \
    -o ''${out}/bin/ln \
    ${src}
''
