{ lib }:

{
  meta = {
    description = "GNU sed, a batch stream editor";
    homepage = "https://www.gnu.org/software/sed";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    mainProgram = "sed";
    platforms = lib.platforms.unix;
  };
}
