{ lib }:
{
  meta = {
    description = "The GNU Core Utilities";
    homepage = "https://www.gnu.org/software/coreutils";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.unix;
  };
}
