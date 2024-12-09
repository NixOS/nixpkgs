{ lib }:

{
  meta = with lib; {
    description = "GNU implementation of the Awk programming language";
    homepage = "https://www.gnu.org/software/gawk";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
}
