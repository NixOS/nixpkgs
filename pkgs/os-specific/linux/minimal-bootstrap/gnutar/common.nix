{ lib }:
{
  meta = with lib; {
    description = "GNU implementation of the `tar' archiver";
    homepage = "https://www.gnu.org/software/tar";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    mainProgram = "tar";
    platforms = platforms.unix;
  };
}
