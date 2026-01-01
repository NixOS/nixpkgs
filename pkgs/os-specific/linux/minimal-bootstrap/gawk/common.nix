{ lib }:

{
<<<<<<< HEAD
  meta = {
    description = "GNU implementation of the Awk programming language";
    homepage = "https://www.gnu.org/software/gawk";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "GNU implementation of the Awk programming language";
    homepage = "https://www.gnu.org/software/gawk";
    license = licenses.gpl3Plus;
    teams = [ teams.minimal-bootstrap ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
