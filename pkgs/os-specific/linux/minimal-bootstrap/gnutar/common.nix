{ lib }:
{
  meta = {
    description = "GNU implementation of the `tar' archiver";
    homepage = "https://www.gnu.org/software/tar";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    mainProgram = "tar";
    platforms = lib.platforms.unix;
  };
}
