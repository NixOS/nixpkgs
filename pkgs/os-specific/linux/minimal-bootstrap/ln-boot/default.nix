{ lib
, kaem
, mes
}:
let
  pname = "ln-boot";
  version = "unstable-2023-05-01";

  src = ./ln.c;
in
kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  meta = with lib; {
    description = "Basic tool for creating symbolic links";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
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
