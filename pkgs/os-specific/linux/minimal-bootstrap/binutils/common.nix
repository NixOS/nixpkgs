{ lib }:
{
  meta = {
    description = "Tools for manipulating binaries (linker, assembler, etc.)";
    homepage = "https://www.gnu.org/software/binutils";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.unix;
  };
}
