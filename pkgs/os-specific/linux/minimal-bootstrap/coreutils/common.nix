{ lib }:
{
  meta = with lib; {
    description = "The GNU Core Utilities";
    homepage = "https://www.gnu.org/software/coreutils";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
}
