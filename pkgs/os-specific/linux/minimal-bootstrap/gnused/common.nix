{ lib }:

{
  meta = with lib; {
    description = "GNU sed, a batch stream editor";
    homepage = "https://www.gnu.org/software/sed";
    license = licenses.gpl3Plus;
    teams = [ teams.minimal-bootstrap ];
    mainProgram = "sed";
    platforms = platforms.unix;
  };
}
