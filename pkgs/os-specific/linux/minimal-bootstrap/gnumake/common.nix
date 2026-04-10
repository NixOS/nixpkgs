{ lib }:
{
  meta = {
    description = "A tool to control the generation of non-source files from sources";
    homepage = "https://www.gnu.org/software/make";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    mainProgram = "make";
    platforms = lib.platforms.unix;
  };
}
