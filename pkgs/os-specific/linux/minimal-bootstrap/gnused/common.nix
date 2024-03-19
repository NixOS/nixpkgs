{ lib }:

{
  meta = with lib; {
    description = "GNU sed, a batch stream editor";
    homepage = "https://www.gnu.org/software/sed";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    mainProgram = "sed";
    platforms = platforms.unix;
  };
}
