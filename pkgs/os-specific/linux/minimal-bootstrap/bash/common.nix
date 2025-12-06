{ lib }:
{
  meta = with lib; {
    description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
    homepage = "https://www.gnu.org/software/bash";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
}
