{ lib }:
{
  meta = with lib; {
    description = "A tool to control the generation of non-source files from sources";
    homepage = "https://www.gnu.org/software/make";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    mainProgram = "make";
    platforms = platforms.unix;
  };
}
